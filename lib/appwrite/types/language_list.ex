defmodule Appwrite.Types.LanguageList do
  @moduledoc """
  Represents a list of languages.

  ## Fields

    - `total` (`integer`): Total number of languages that matched the query.
    - `languages` (`[Appwrite.Types.Language.t]`): List of languages.
  """

  @type t :: %__MODULE__{
          total: integer(),
          languages: [Appwrite.Types.Language.t()]
        }

  defstruct [:total, :languages]
end
