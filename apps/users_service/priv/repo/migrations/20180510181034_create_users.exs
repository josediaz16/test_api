defmodule UsersService.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false, default: ""
      add :email, :string, null: false, default: ""
      add :password_hash, :string, null: false, default: ""
      add :phone_number, :string, null: false, default: ""
      add :country, :string, null: false, default: ""
      add :city, :string, null: false, default: ""
      add :address, :string, null: false, default: ""
    end
  end
end
