defmodule Rushing.Stats.RushingStats do
  @moduledoc """
  Rushing Stats Schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "rushing_stats" do
    field :player_name, :string
    field :team, :string
    field :position, :string
    field :attempts, :integer
    field :attempts_avg, :float
    field :yards, :integer
    field :yards_avg, :float
    field :touchdowns, :integer
    field :longest, :string
    field :longest_first_down_percentage, :float
    field :twenty_plus_yards, :integer
    field :forty_plus_yards, :integer
    field :fumbles, :integer

    timestamps()
  end

  @attrs ~w(
    player_name
    team
    position
    attempts
    attempts_avg
    yards
    yards_avg
    touchdowns
    longest
    longest_first_down_percentage
    twenty_plus_yards
    forty_plus_yards
    fumbles
  )

  @doc false
  def import_changeset(rushing_stats, attrs) do
    rushing_stats
    |> cast(attrs, @attrs)
    |> validate_required([:player_name, :team])
  end
end
