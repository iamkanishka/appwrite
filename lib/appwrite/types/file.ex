defmodule Appwrite.Types.File do
  @moduledoc """
  A file stored in an Appwrite Storage bucket.

  System fields (`$id`, `$createdAt`, etc.) are mapped to snake_case.

  ## Fields

  - `id` (`String.t()`) — file ID (`$id`).
  - `bucket_id` (`String.t()`) — parent bucket ID (`bucketId`).
  - `created_at` (`String.t()`) — upload timestamp in ISO 8601 (`$createdAt`).
  - `updated_at` (`String.t()`) — last-updated timestamp in ISO 8601 (`$updatedAt`).
  - `permissions` (`[String.t()]`) — Appwrite permission strings (`$permissions`).
  - `name` (`String.t()`) — original file name.
  - `signature` (`String.t()`) — MD5 signature of the file content.
  - `mime_type` (`String.t()`) — detected MIME type.
  - `size_original` (`non_neg_integer()`) — original file size in bytes.
  - `chunks_total` (`non_neg_integer()`) — total chunks for chunked uploads.
  - `chunks_uploaded` (`non_neg_integer()`) — chunks successfully uploaded so far.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          id: String.t(),
          bucket_id: String.t(),
          created_at: String.t(),
          updated_at: String.t(),
          permissions: [String.t()],
          name: String.t(),
          signature: String.t(),
          mime_type: String.t(),
          size_original: non_neg_integer(),
          chunks_total: non_neg_integer(),
          chunks_uploaded: non_neg_integer()
        }

  defstruct [
    :id,
    :bucket_id,
    :created_at,
    :updated_at,
    :permissions,
    :name,
    :signature,
    :mime_type,
    :size_original,
    :chunks_total,
    :chunks_uploaded
  ]
end
