defmodule Appwrite.Types.Client.Payload do
  @moduledoc """
  Type alias for a generic API request or event payload map.

  Represents a flat map of string keys to arbitrary values. Used for
  request bodies sent to the Appwrite API and for the `payload` field
  of incoming `RealtimeResponseEvent` messages.

  ## Example

      %{
        "name"   => "My File",
        "size"   => 1024,
        "public" => true
      }
  """

  @type t :: %{required(String.t()) => any()}
end
