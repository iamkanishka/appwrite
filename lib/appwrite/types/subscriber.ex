defmodule Appwrite.Types.Subscriber do
  @moduledoc """
  Represents a subscriber to an Appwrite Messaging topic.

  A subscriber links a user's messaging `Target` (email address, phone
  number, or push token) to a specific topic so that messages sent to
  that topic are delivered to that target.

  ## Fields

    - `id` (`String.t()`): Subscriber ID.
    - `created_at` (`String.t()`): Subscriber creation date in ISO 8601 format.
    - `updated_at` (`String.t()`): Subscriber update date in ISO 8601 format.
    - `target_id` (`String.t()`): ID of the associated messaging target.
    - `target` (`Appwrite.Types.Target.t() | nil`): Embedded target object, or `nil` if not expanded.
    - `user_id` (`String.t()`): ID of the user who owns this subscriber.
    - `user_name` (`String.t()`): Name of the user who owns this subscriber.
    - `topic_id` (`String.t()`): ID of the topic this subscriber belongs to.
    - `provider_type` (`String.t()`): Provider type. One of `"email"`, `"sms"`, or `"push"`.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          id: String.t(),
          created_at: String.t(),
          updated_at: String.t(),
          target_id: String.t(),
          target: Appwrite.Types.Target.t() | nil,
          user_id: String.t(),
          user_name: String.t(),
          topic_id: String.t(),
          provider_type: String.t()
        }

  defstruct [
    :id,
    :created_at,
    :updated_at,
    :target_id,
    :target,
    :user_id,
    :user_name,
    :topic_id,
    :provider_type
  ]
end
