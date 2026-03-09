defmodule Appwrite.Types.Client.UploadProgress do
  @moduledoc """
  Represents the progress of a chunked file upload.

  Emitted by the storage service during large file uploads so that
  callers can report progress to users or implement retry logic.

  ## Fields

    - `id` (`String.t()`) — ID of the file being uploaded.
    - `progress` (`0..100`) — Upload completion percentage (0–100).
    - `size_uploaded` (`non_neg_integer()`) — Number of bytes uploaded so far.
    - `chunks_total` (`non_neg_integer()`) — Total number of chunks the file
      was split into.
    - `chunks_uploaded` (`non_neg_integer()`) — Number of chunks successfully
      uploaded so far.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          id: String.t(),
          progress: 0..100,
          size_uploaded: non_neg_integer(),
          chunks_total: non_neg_integer(),
          chunks_uploaded: non_neg_integer()
        }

  defstruct [
    :id,
    :progress,
    :size_uploaded,
    :chunks_total,
    :chunks_uploaded
  ]
end
