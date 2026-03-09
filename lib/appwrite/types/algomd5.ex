defmodule Appwrite.Types.AlgoMd5 do
  @moduledoc """
  Parameters for the MD5 hashing algorithm.

  MD5 is supported for legacy password migration only and carries no
  additional parameters beyond the type tag.

  ## Fields

  - `type` (`String.t()`) — always `"md5"`.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{type: String.t()}

  defstruct [:type]
end
