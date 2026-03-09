defmodule Appwrite.Types.Country do
  @moduledoc """
  A country record returned by `GET /v1/locale/countries`.

  ## Fields

  - `name` (`String.t()`) — human-readable country name (e.g. `"India"`).
  - `code` (`String.t()`) — ISO 3166-1 alpha-2 code (e.g. `"IN"`).
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          name: String.t(),
          code: String.t()
        }

  defstruct [:name, :code]
end
