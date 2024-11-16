defmodule Appwrite.Types.Membership do
  @moduledoc """
  Represents a membership in a team.

  ## Fields

    - `$id` (`String.t`): Membership ID.
    - `$created_at` (`String.t`): Creation date in ISO 8601 format.
    - `$updated_at` (`String.t`): Update date in ISO 8601 format.
    - `user_id` (`String.t`): User ID.
    - `user_name` (`String.t`): User name.
    - `user_email` (`String.t`): User email address.
    - `team_id` (`String.t`): Team ID.
    - `team_name` (`String.t`): Team name.
    - `invited` (`String.t`): Invitation date in ISO 8601 format.
    - `joined` (`String.t`): Joining date in ISO 8601 format.
    - `confirm` (`boolean`): Confirmation status.
    - `mfa` (`boolean`): MFA status.
    - `roles` (`[String.t]`): List of user roles.
  """

  @type t :: %__MODULE__{
          id: String.t(),
          created_at: String.t(),
          updated_at: String.t(),
          user_id: String.t(),
          user_name: String.t(),
          user_email: String.t(),
          team_id: String.t(),
          team_name: String.t(),
          invited: String.t(),
          joined: String.t(),
          confirm: boolean(),
          mfa: boolean(),
          roles: [String.t()]
        }

  defstruct [
    :id,
    :created_at,
    :updated_at,
    :user_id,
    :user_name,
    :user_email,
    :team_id,
    :team_name,
    :invited,
    :joined,
    :confirm,
    :mfa,
    :roles
  ]
end
