defmodule Appwrite.Types.DocumentList do
  @moduledoc """
  Represents a list of documents.

  ## Fields

    - `total` (`integer`): Total number of documents that matched the query.
    - `documents` (`[Document]`): List of documents.
  """

  @type t :: %__MODULE__{
          total: integer(),
          documents: [Appwrite.Types.Document.t()]
        }

  defstruct [:total, :documents]
end
