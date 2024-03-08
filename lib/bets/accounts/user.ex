defmodule Bets.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bets.Repo
  alias Bets.Accounts.User

  @derive {Jason.Encoder, only: [:id, :name, :email, :role, :confirmed_at, :game_id, :bet_id, :admin_id]}
  schema "users" do
    field :name, :string, default: ""
    field :email, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :confirmed_at, :naive_datetime, default: DateTime.utc_now() |> NaiveDateTime.truncate(:second)
    field :role, Ecto.Enum, values: [:user, :admin, :superuser], default: :user
    field :game_id, :integer
    field :bet_id, :integer
    field :admin_id, :integer
    field :player_id, :integer

    has_many :games, Bets.Games.Game
    has_many :bets, Bets.Wagers.Bet
    has_many :players, Bets.Players.Player

    timestamps(type: :utc_datetime)

  def changeset(user, attrs) do
      user
      |> cast(attrs, [:name, :email, :hashed_password, :confirmed_at, :role, :game_id, :bet_id, :admin_id, :player_id])
      |> validate_required([:name, :email])
      |> validate_format(:email, ~r/@/)
      |> validate_length(:password, min: 6, allow_nil: true)
      |> validate_inclusion(:role, [:user, :admin, :superuser])
    end
  end

  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_email(opts)
    |> validate_password(opts)
  end

  defp validate_email(changeset, opts) do
    changeset
    |> validate_required([:email])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> maybe_validate_unique_email(opts)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 8, max: 72)
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      |> validate_length(:password, max: 72, count: :bytes)
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

  def email_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email])
    |> validate_email(opts)
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  def confirm_changeset(user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  def valid_password?(%Bets.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
        Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  
@doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
"""
def create_user(%Ueberauth.Auth.Info{} = attrs) do
  try do
    hashed_password = Bcrypt.hash_pwd_salt(attrs.name <> attrs.email)

    attrs = Map.put(attrs, :hashed_password, hashed_password)
    attrs = Map.put(attrs, :confirmed_at, DateTime.utc_now() |> NaiveDateTime.truncate(:second))
    attrs = Map.from_struct(attrs)

    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  rescue
    exception ->
      {:error, "User already exists!"}
  end
end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_user(attrs \\ {}) do
    try do
      hashed_password = Bcrypt.hash_pwd_salt(attrs["password"])
      attrs = Map.put(attrs, "hashed_password", hashed_password)
      attrs = Map.put(attrs, "confirmed_at", DateTime.utc_now() |> NaiveDateTime.truncate(:second))
      
      %User{}
      |> User.changeset(attrs)
      |> Repo.insert()
    rescue
      exception ->
        {:error, exception}
        IO.inspect(exception, label: "exception")
    end
  end

  def get_user!(id), do: Repo.get!(User, id)

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
  def change_user(changeset, attrs \\ %{}) do
    %User{}
    |> cast(attrs, [:name, :email, :password, :confirmed_at, :role, :game_id, :bet_id, :admin_id])
    |> validate_required([:name, :email])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6, allow_nil: true)
    |> validate_inclusion(:role, [:user, :admin, :superuser])
  end

  def get_or_create_user(attrs) do
    case Repo.get_by(User, email: "#attrs.email") do
      nil -> create_user(attrs)
      {:error, _reason} = error -> error
      user -> {:ok, user}
    end
  end
end