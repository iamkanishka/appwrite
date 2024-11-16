defmodule Appwrite.Types.Target do
  @moduledoc """
  Represents a target entity with its details.

  ## Fields

    - `$id` (`String.t`): Target ID.
    - `$created_at` (`String.t`): Creation date in ISO 8601 format.
    - `$updated_at` (`String.t`): Update date in ISO 8601 format.
    - `name` (`String.t`): Target name.
    - `user_id` (`String.t`): User ID.
    - `provider_id` (`String.t` | `nil`): Provider ID.
    - `provider_type` (`String.t`): Provider type (`email`, `sms`, `push`).
    - `identifier` (`String.t`): Target identifier.
  """

  @type t :: %__MODULE__{
          id: String.t(),
          created_at: String.t(),
          updated_at: String.t(),
          name: String.t(),
          user_id: String.t(),
          provider_id: String.t() | nil,
          provider_type: String.t(),
          identifier: String.t()
        }

  defstruct [:id, :created_at, :updated_at, :name, :user_id, :provider_id, :provider_type, :identifier]
end
