defmodule Appwrite.Types.Team do
  @moduledoc """
  Represents a team with details such as name, members, and preferences.

  ## Fields

    - `$id` (`String.t`): Team ID.
    - `$created_at` (`String.t`): Creation date in ISO 8601 format.
    - `$updated_at` (`String.t`): Update date in ISO 8601 format.
    - `name` (`String.t`): Team name.
    - `total` (`integer`): Total number of team members.
    - `prefs` (`map`): Team preferences as a key-value object.
  """

  @type t :: %__MODULE__{
          id: String.t(),
          created_at: String.t(),
          updated_at: String.t(),
          name: String.t(),
          total: integer(),
          prefs: Appwrite.Types.Preference.t()
        }

  defstruct [:id, :created_at, :updated_at, :name, :total, :prefs]
end
