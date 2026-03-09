defmodule Appwrite.Types.User do
  @moduledoc """
  Represents an Appwrite user account.

  Contains identity information, authentication state, MFA status,
  preferences, and the list of messaging targets owned by the user.

  ## Fields

    - `id` (`String.t()`): User ID.
    - `created_at` (`String.t()`): Account creation date in ISO 8601 format.
    - `updated_at` (`String.t()`): Account update date in ISO 8601 format.
    - `name` (`String.t()`): User display name.
    - `password` (`String.t() | nil`): Hashed password. `nil` for OAuth2-only accounts.
    - `hash` (`String.t() | nil`): Password hashing algorithm identifier. `nil` for OAuth2-only accounts.
    - `hash_options` (`map() | nil`): Parameters used by the hashing algorithm. `nil` for OAuth2-only accounts.
    - `registration` (`String.t()`): Account registration date in ISO 8601 format.
    - `status` (`boolean()`): Account status. `true` for enabled, `false` for disabled.
    - `labels` (`[String.t()]`): List of labels attached to the user.
    - `password_update` (`String.t()`): Date the password was last changed in ISO 8601 format.
    - `email` (`String.t()`): User email address (empty string if not set).
    - `phone` (`String.t()`): User phone number in E.164 format (empty string if not set).
    - `email_verification` (`boolean()`): Whether the email address has been verified.
    - `phone_verification` (`boolean()`): Whether the phone number has been verified.
    - `mfa` (`boolean()`): Whether multi-factor authentication is enabled.
    - `prefs` (`Appwrite.Types.Preference.t()`): User preferences as a string-keyed map.
    - `targets` (`[Appwrite.Types.Target.t()]`): List of messaging targets owned by this user.
    - `accessed_at` (`String.t()`): Date of the most recent account access in ISO 8601 format.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          id: String.t(),
          created_at: String.t(),
          updated_at: String.t(),
          name: String.t(),
          password: String.t() | nil,
          hash: String.t() | nil,
          hash_options: map() | nil,
          registration: String.t(),
          status: boolean(),
          labels: [String.t()],
          password_update: String.t(),
          email: String.t(),
          phone: String.t(),
          email_verification: boolean(),
          phone_verification: boolean(),
          mfa: boolean(),
          prefs: Appwrite.Types.Preference.t(),
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
