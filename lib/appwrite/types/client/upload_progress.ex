defmodule Appwrite.UploadProgress do
  @moduledoc """
  Type representing upload progress information.
  """
  defstruct [
    :id,
    :progress,
    :size_uploaded,
    :chunks_total,
    :chunks_uploaded
  ]

  @type t :: %__MODULE__{
          id: String.t(),
          progress: non_neg_integer(),
          size_uploaded: non_neg_integer(),
          chunks_total: non_neg_integer(),
          chunks_uploaded: non_neg_integer()
        }
end
