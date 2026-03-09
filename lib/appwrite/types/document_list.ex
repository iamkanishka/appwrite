defmodule Appwrite.Types.DocumentList do
  @moduledoc """
  Paginated list of `Appwrite.Types.Document` records.

  ## Fields

  - `total` (`non_neg_integer()`) — total documents matching the query.
  - `documents` (`[Appwrite.Types.Document.t()]`) — current page of results.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          total: non_neg_integer(),
          documents: [Appwrite.Types.Document.t()]
        }

  defstruct [:total, :documents]
end
