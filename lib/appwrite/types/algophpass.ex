defmodule Appwrite.Types.AlgoPhpass do
  @moduledoc """
  Parameters for the PHPass (Portable PHP password hashing) algorithm.

  PHPass is supported for legacy password migration and carries no
  additional parameters beyond the type tag.

  ## Fields

  - `type` (`String.t()`) — always `"phpass"`.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{type: String.t()}

  defstruct [:type]
end
