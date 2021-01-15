defmodule Rushing.Repo.Migrations.CreateRushingStats do
  use Ecto.Migration

  @moduledoc """
  Create a web app. This must be able to do the following steps:
  - Create a webpage which displays a table with the contents of rushing.json
  - The user should be able to sort the players by Total Rushing Yards, Longest Rush and Total Rushing Touchdowns
    - Yds (Total Rushing Yards)
    - Lng (Longest Rush -- a T represents a touchdown occurred)
    - TD (Total Rushing Touchdowns)
  - The user should be able to filter by the player's name
  - The user should be able to download the sorted data as a CSV, as well as a filtered subset
  - The system should be able to potentially support larger sets of data on the order of 10k records.
  - Update the section Installation and running this solution in the README file explaining how to run your code
  """

  def change do
    create table(:rushing_stats) do
      add :player, :string
      add :team, :string
      add :position, :integer
      add :price, :float
      add :price, :float
      add :price, :decimal, precision: 10, scale: 2
      add :published_at, :utc_datetime
      add :group_id, references(:groups)
      add :object, :json
    end
  end
end
