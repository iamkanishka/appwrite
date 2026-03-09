defmodule Appwrite.Types.Team do
  @moduledoc """
  Represents a team in Appwrite.

  Teams allow grouping of users and are used to manage shared access to
  resources via roles and memberships.

  ## Fields

    - `id` (`String.t()`): Team ID.
    - `created_at` (`String.t()`): Team creation date in ISO 8601 format.
    - `updated_at` (`String.t()`): Team update date in ISO 8601 format.
    - `name` (`String.t()`): Team name.
    - `total` (`non_neg_integer()`): Total number of team members.
    - `prefs` (`Appwrite.Types.Preference.t()`): Team preferences as a string-keyed map.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          id: String.t(),
          created_at: String.t(),
          updated_at: String.t(),
          name: String.t(),
          total: non_neg_integer(),
          prefs: Appwrite.Types.Preference.t()
        }

  defstruct [:id, :created_at, :updated_at, :name, :total, :prefs]
end
