defmodule UsersService.User do
  use Ecto.Schema
  @derive {Poison.Encoder, except: [:__meta__, :password, :password_confirmation, :password_hash]}

  schema "users" do
    field :name,                  :string
    field :email,                 :string
    field :password_hash,         :string
    field :password,              :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :phone_number,          :string
    field :country,               :string
    field :city,                  :string
    field :address,               :string
  end

  def changeset(user, params \\ %{}) do
    user
      |> Ecto.Changeset.cast(params, [:name, :email, :password, :phone_number, :country, :city, :address])
      |> Ecto.Changeset.validate_required([:name, :email, :password, :phone_number])
      |> Ecto.Changeset.validate_format(:email, ~r/@/)
      |> Ecto.Changeset.validate_confirmation(:password)
      |> hash_password
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        Ecto.Changeset.put_change(changeset,
          :password_hash,
          Comeonin.Bcrypt.hashpwsalt(password)
        )
      _ -> changeset
    end
  end
end
