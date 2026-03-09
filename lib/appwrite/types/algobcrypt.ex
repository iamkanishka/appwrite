defmodule Appwrite.Types.AlgoBcrypt do
  @moduledoc """
  Parameters for the Bcrypt password hashing algorithm.

  Bcrypt derives all settings from the stored hash; no extra parameters
  are needed beyond the algorithm type tag.

  ## Fields

  - `type` (`String.t()`) — always `"bcrypt"`.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{type: String.t()}

  defstruct [:type]
end
