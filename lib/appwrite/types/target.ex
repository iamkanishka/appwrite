defmodule Appwrite.Types.Target do
  @moduledoc """
  Represents a messaging target owned by a user.

  A target is a specific delivery endpoint — an email address, a phone
  number, or a push notification token — that can be subscribed to
  Appwrite Messaging topics.

  ## Fields

    - `id` (`String.t()`): Target ID.
    - `created_at` (`String.t()`): Target creation date in ISO 8601 format.
    - `updated_at` (`String.t()`): Target update date in ISO 8601 format.
    - `name` (`String.t()`): Target display name.
    - `user_id` (`String.t()`): ID of the user who owns this target.
    - `provider_id` (`String.t() | nil`): ID of the associated messaging provider, or `nil` if unset.
    - `provider_type` (`String.t()`): Provider type. One of `"email"`, `"sms"`, or `"push"`.
    - `identifier` (`String.t()`): Delivery identifier — the email address, phone number, or device token.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          id: String.t(),
          created_at: String.t(),
          updated_at: String.t(),
          name: String.t(),
          user_id: String.t(),
          provider_id: String.t() | nil,
          provider_type: String.t(),
          identifier: String.t()
        }

  defstruct [
    :id,
    :created_at,
    :updated_at,
    :name,
    :user_id,
    :provider_id,
    :provider_type,
    :identifier
  ]
end
