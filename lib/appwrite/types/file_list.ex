defmodule FileList do
  @moduledoc """
  Represents a list of files.

  ## Fields

    - `total` (`integer`): Total number of files that matched the query.
    - `files` (`[Appwrite.Types.File.t]`): List of files.
  """

  @type t :: %__MODULE__{
          total: integer(),
          files: [Appwrite.Types.File.t()]
        }

  defstruct [:total, :files]
end
