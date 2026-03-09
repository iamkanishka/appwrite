defmodule Appwrite.Consts.AuthenticationFactor do
  @moduledoc """
  Valid MFA authentication factor identifiers.

  | Constant        | Value            |
  |-----------------|------------------|
  | email           | `"email"`        |
  | phone           | `"phone"`        |
  | totp            | `"totp"`         |
  | recovery code   | `"recoverycode"` |
  """

  use Appwrite.Consts.Behaviour,
    values: ~w(email phone totp recoverycode),
    name:   "authentication factor"
end
