defmodule Appwrite.Services.Messaging do
  @moduledoc """
  The Messaging service allows you to send messages to any provider type
  (SMTP, push notification, SMS, etc.).

  Using the Messaging service, you can send targeted messages to users based
  on topics or one-time messages directly to users. Providers can be
  configured in the Appwrite console.
  """

  use Appwrite.Services.Base

  alias Appwrite.Types.Subscriber

  @doc """
  Create a new subscriber for a topic.

  Subscribes a user's messaging target to the specified topic so that messages
  sent to the topic are delivered to that target.

  ## Parameters
  - `topic_id` (`String.t()`): The ID of the topic to subscribe to.
  - `subscriber_id` (`String.t()`): Unique subscriber ID. Use a custom ID or
    generate one with `ID.unique()`. Valid chars: a-z, A-Z, 0-9, `.`, `-`, `_`.
    Cannot start with a special character. Max length: 36 chars.
  - `target_id` (`String.t()`): The target ID to link to this topic.

  ## Returns
  - `{:ok, Subscriber.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.

  ## Examples

      iex> Appwrite.Services.Messaging.create_subscriber("topic_id", "unique()", "target_id")
      {:ok, %Appwrite.Types.Subscriber{}}
  """
  @spec create_subscriber(String.t(), String.t(), String.t()) ::
          {:ok, Subscriber.t()} | {:error, AppwriteException.t()}
  def create_subscriber(topic_id, subscriber_id, target_id) do
    with :ok <-
           require_all(topic_id: topic_id, subscriber_id: subscriber_id, target_id: target_id) do
      payload = %{"subscriberId" => subscriber_id, "targetId" => target_id}
      json_call("POST", "/v1/messaging/topics/\#{topic_id}/subscribers", payload)
    end
  end

  @doc """
  Delete a subscriber by its unique ID.

  ## Parameters
  - `topic_id` (`String.t()`): The ID of the topic the subscriber belongs to.
  - `subscriber_id` (`String.t()`): The subscriber ID.

  ## Returns
  - `{:ok, map()}` on success.
  - `{:error, AppwriteException.t()}` on failure.

  ## Examples

      iex> Appwrite.Services.Messaging.delete_subscriber("topic_id", "subscriber_id")
      {:ok, %{}}
  """
  @spec delete_subscriber(String.t(), String.t()) ::
          {:ok, map()} | {:error, AppwriteException.t()}
  def delete_subscriber(topic_id, subscriber_id) do
    with :ok <- require_all(topic_id: topic_id, subscriber_id: subscriber_id) do
      json_call("DELETE", "/v1/messaging/topics/\#{topic_id}/subscribers/\#{subscriber_id}", %{})
    end
  end
end
