defmodule Appwrite.Types.File do
  @moduledoc """
  Represents a file in the Appwrite storage system.

  ## Fields

    - `id` (`String.t`): File ID.
    - Other fields include metadata such as bucket ID, name, and file properties.
  """

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
