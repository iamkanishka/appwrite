defmodule Appwrite.Types.Document do
  @moduledoc """
  Represents a document in the Appwrite database.

  ## Fields

    - `id` (`String.t`): Document ID.
    - `collection_id` (`String.t`): Collection ID.
    - `database_id` (`String.t`): Database ID.
    - `created_at` (`String.t`): Document creation date in ISO 8601 format.
    - `updated_at` (`String.t`): Document update date in ISO 8601 format.
    - `permissions` (`list(String.t)`): Document permissions. See [Appwrite permissions](https://appwrite.io/docs/permissions).
    - `data` (`map`): Key-value pairs representing additional document data.
  """

  @type t :: %__MODULE__{
          id: String.t(),
          collection_id: String.t(),
          database_id: String.t(),
          created_at: String.t(),
          updated_at: String.t(),
          permissions: [String.t()],
          data: map()
        }

  defstruct [
    :id,
    :collection_id,
    :database_id,
    :created_at,
    :updated_at,
    :permissions,
    :data
  ]
end
