defmodule Appwrite.Types.AlgoSha do
  @moduledoc """
  Parameters for the SHA-family hashing algorithms.

  SHA variants (SHA-1, SHA-256, etc.) are supported for legacy migration
  and carry no additional parameters beyond the type tag.

  ## Fields

  - `type` (`String.t()`) — always `"sha"`.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{type: String.t()}

  defstruct [:type]
end
