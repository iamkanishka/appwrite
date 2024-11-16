defmodule Appwrite.Types.MfaChallenge do
  @moduledoc """
  Represents an MFA challenge.

  ## Fields

    - `$id` (`String.t`): Token ID.
    - `$created_at` (`String.t`): Token creation date in ISO 8601 format.
    - `user_id` (`String.t`): User ID.
    - `expire` (`String.t`): Token expiration date in ISO 8601 format.
  """

  @type t :: %__MODULE__{
          id: String.t(),
          created_at: String.t(),
          user_id: String.t(),
          expire: String.t()
        }

  defstruct [:id, :created_at, :user_id, :expire]
end
