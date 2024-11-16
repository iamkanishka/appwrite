defmodule Appwrite.Types.User do
  @moduledoc """
  Represents a user, including details such as preferences, verification status, and associated targets.

  ## Fields

    - `id` (`String.t`): User ID.
    - `created_at` (`String.t`): Creation date in ISO 8601 format.
    - `updated_at` (`String.t`): Update date in ISO 8601 format.
    - `name` (`String.t`): User name.
    - `password` (`String.t | nil`): Hashed user password.
    - `hash` (`String.t | nil`): Password hashing algorithm.
    - `hash_options` (`map | nil`): Password hashing algorithm configuration.
    - `registration` (`String.t`): User registration date in ISO 8601 format.
    - `status` (`boolean`): User status. `true` for enabled, `false` for disabled.
    - `labels` (`[String.t]`): Labels associated with the user.
    - `password_update` (`String.t`): Password update time in ISO 8601 format.
    - `email` (`String.t`): User email address.
    - `phone` (`String.t`): User phone number in E.164 format.
    - `email_verification` (`boolean`): Email verification status.
    - `phone_verification` (`boolean`): Phone verification status.
    - `mfa` (`boolean`): Multi-factor authentication status.
    - `prefs` (`map`): User preferences as a key-value object.
    - `targets` (`[Appwrite.Types.Target.t]`): List of user-owned message receivers.
    - `accessed_at` (`String.t`): Most recent access date in ISO 8601 format.
  """

  @type t :: %__MODULE__{
          id: String.t(),
          created_at: String.t(),
          updated_at: String.t(),
          name: String.t(),
          password: String.t() | nil,
          hash: String.t() | nil,
          hash_options: map | nil,
          registration: String.t(),
          status: boolean(),
          labels: [String.t()],
          password_update: String.t(),
          email: String.t(),
          phone: String.t(),
          email_verification: boolean(),
          phone_verification: boolean(),
          mfa: boolean(),
          prefs: Appwrite.Types.Preference,
          targets: [Appwrite.Types.Target.t()],
          accessed_at: String.t()
        }

  defstruct [
    :id,
    :created_at,
    :updated_at,
    :name,
    :password,
    :hash,
    :hash_options,
    :registration,
    :status,
    :labels,
    :password_update,
    :email,
    :phone,
    :email_verification,
    :phone_verification,
    :mfa,
    :prefs,
    :targets,
    :accessed_at
  ]
end
