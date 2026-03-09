defmodule Appwrite.Types.Membership do
  @moduledoc """
  Represents a user's membership in an Appwrite team.

  A membership is created when a user is invited to or joins a team.
  It records the invitation and joining dates, the roles granted, and
  whether MFA is enforced for the membership.

  ## Fields

    - `id` (`String.t()`): Membership ID.
    - `created_at` (`String.t()`): Membership creation date in ISO 8601 format.
    - `updated_at` (`String.t()`): Membership update date in ISO 8601 format.
    - `user_id` (`String.t()`): ID of the user.
    - `user_name` (`String.t()`): Name of the user.
    - `user_email` (`String.t()`): Email address of the user.
    - `team_id` (`String.t()`): ID of the team.
    - `team_name` (`String.t()`): Name of the team.
    - `invited` (`String.t()`): Date when the user was invited in ISO 8601 format.
    - `joined` (`String.t()`): Date when the user accepted the invitation in ISO 8601 format.
    - `confirm` (`boolean()`): Whether the membership invitation has been confirmed.
    - `mfa` (`boolean()`): Whether MFA is enforced for this membership.
    - `roles` (`[String.t()]`): List of roles assigned to the user within this team.
  """

  @derive Jason.Encoder

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
