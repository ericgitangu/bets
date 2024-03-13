defmodule Bets.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  require Logger

  alias Bets.Repo
  alias Bets.Accounts.User

  @derive {Jason.Encoder,
           only: [:id, :name, :email, :role, :confirmed_at, :game_id, :bet_id, :admin_id]}
  schema "users" do
    field :name, :string, default: "Anonymous"
    field :email, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true

    field :confirmed_at, :naive_datetime,
      default: DateTime.utc_now() |> NaiveDateTime.truncate(:second)

    field :role, Ecto.Enum, values: [:user, :admin, :superuser], default: :user
    field :game_id, :integer
    field :bet_id, :integer
    field :admin_id, :integer
    field :player_id, :integer

    has_many :games, Bets.Games.Game
    has_many :bets, Bets.Wagers.Bet
    has_many :players, Bets.Players.Player

    timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :hashed_password, :role, :confirmed_at, :game_id, :bet_id, :admin_id])
    |> validate_required([:name, :email, :hashed_password, :role, :confirmed_at])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.

    * `:validate_email` - Validates the uniqueness of the email, in case
      you don't want to validate the uniqueness of the email (like when
      using this changeset for validations on a LiveView form before
      submitting the form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_email(opts)
    |> validate_password(opts)
  end

  defp validate_email(changeset, opts) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> maybe_validate_unique_email(opts)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 8, max: 72)
    # Examples of additional password validation:
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      # Hashing could be done with `Ecto.Changeset.prepare_changes/2`, but that
      # would keep the database transaction open longer and hurt performance.
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  defp maybe_validate_unique_email(changeset, opts) do
    if Keyword.get(opts, :validate_email, true) do
      changeset
      |> unsafe_validate_unique(:email, Bets.Repo)
      |> unique_constraint(:email)
    else
      changeset
    end
  end

  @doc """
  A user changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email])
    |> validate_email(opts)
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  A user changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Bets.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end

  @doc """
  Updates a user.

  ## Examples

  iex> update_user(user, %{field: new_value})
  {:ok, %User{}}

  iex> update_user(user, %{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

  iex> delete_user(user)
  {:ok, %User{}}

  iex> delete_user(user)
  {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

  iex> change_user(user)
  %Ecto.Changeset{data: %User{}}

  """
  def change_user(_changeset, attrs \\ %{}) do
    %User{}
    |> cast(attrs, [:name, :email, :password, :confirmed_at, :role, :game_id, :bet_id, :admin_id])
    |> validate_required([:name, :email])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6, allow_nil: true)
    |> validate_inclusion(:role, [:user, :admin, :superuser])
  end

  @doc """
  Returns a user or creates a new one if it does not exist.

  ## Examples

  iex> get_or_create_user(%{email: "foobar#email.com")
  {:ok, %User{}}
  iex> get_or_create_user(%{email: "foobar#email.com")
  {:error, %Ecto.Changeset{}}
  """
  def create_user(%Ueberauth.Auth.Info{name: name, email: email} = _attrs) do
    confirmed_at = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    password = Bcrypt.hash_pwd_salt("#{confirmed_at}#{email}")
    user = %User{name: name, email: email, hashed_password: password, confirmed_at: confirmed_at}

    case Repo.insert(user, on_conflict: :nothing) do
      {:ok, user} ->
        {:ok, user}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def create_user(attrs \\ %{}) do
    Logger.debug("Attributes, #{inspect(attrs)}")
    try do
      hashed_password = Bcrypt.hash_pwd_salt("#{attrs["password"]}")
      attrs = Map.put(attrs, "role", "user")
      attrs
      attrs = Map.put(attrs, "hashed_password", hashed_password)
      attrs = Map.put(attrs, "confirmed_at", NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))

      Logger.debug("Attributes, #{inspect(attrs)}")
      %User{}
      |> User.changeset(attrs)
      |> Repo.insert()
    rescue
      exception ->
        {:error, exception}
    end
  end

  @doc """
  Updates a user with the given attributes.

  ## Examples
  iex> update_user!(user, %{name: "John"})
  {:ok, %User{}}
  iex> update_user!(user, %{name: "John"})
  {:error, %Ecto.Changeset{}}
  """
  def get_or_create_user(attrs) do
    case Repo.get_by(User, email: "#attrs.email") do
      nil -> create_user(attrs)
      {:error, _changeset} -> {:error, :invalid_changeset}
      user -> {:ok, user}
    end
  end

  @doc """
  Gets a single user.

  ## Examples
  iex> get_user!(123)
  %User{}
  iex> get_user!(456)
  ** (Ecto.NoResultsError)
  """
  def get_user!(id), do: Repo.get!(User, id)
end
