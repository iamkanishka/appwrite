defmodule Appwrite.Types.Document do
  @moduledoc """
  A document stored in an Appwrite Database collection.

  System fields (`$id`, `$collectionId`, etc.) are mapped to their
  snake_case equivalents (`:id`, `:collection_id`, etc.).

  The `:data` field carries all user-defined attributes returned by the API
  as a plain `map()`.

  ## Fields

  - `id` (`String.t()`) — document ID (`$id`).
  - `collection_id` (`String.t()`) — parent collection ID (`$collectionId`).
  - `database_id` (`String.t()`) — parent database ID (`$databaseId`).
  - `created_at` (`String.t()`) — creation timestamp in ISO 8601 (`$createdAt`).
  - `updated_at` (`String.t()`) — last-updated timestamp in ISO 8601 (`$updatedAt`).
  - `permissions` (`[String.t()]`) — Appwrite permission strings (`$permissions`).
  - `data` (`map()`) — user-defined attribute key-value pairs.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          id: String.t(),
          collection_id: String.t(),
          database_id: String.t(),
          created_at: String.t(),
          updated_at: String.t(),
          permissions: [String.t()],
          data: map()
        }

  defstruct id: nil,
            collection_id: nil,
            database_id: nil,
            created_at: nil,
            updated_at: nil,
            permissions: [],
            data: nil
end
