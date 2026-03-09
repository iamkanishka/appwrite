defmodule Appwrite.Consts.AuthenticationType do
  @moduledoc """
  Valid MFA authenticator types.

  | Constant | Value    |
  |----------|----------|
  | totp     | `"totp"` |
  """

  use Appwrite.Consts.Behaviour,
    values: ~w(totp),
    name:   "authenticator type"
end
