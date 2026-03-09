defmodule Appwrite.Types.FileList do
  @moduledoc """
  Paginated list of `Appwrite.Types.File` records.

  ## Fields

  - `total` (`non_neg_integer()`) — total files matching the query.
  - `files` (`[Appwrite.Types.File.t()]`) — current page of results.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          total: non_neg_integer(),
          files: [Appwrite.Types.File.t()]
        }

  defstruct [:total, :files]
end
