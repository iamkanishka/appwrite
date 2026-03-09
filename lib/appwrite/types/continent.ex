defmodule Appwrite.Types.Continent do
  @moduledoc """
  A continent record returned by `GET /v1/locale/continents`.

  ## Fields

  - `name` (`String.t()`) — human-readable continent name (e.g. `"Europe"`).
  - `code` (`String.t()`) — two-letter continent code (e.g. `"EU"`).
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          name: String.t(),
          code: String.t()
        }

  defstruct [:name, :code]
end
