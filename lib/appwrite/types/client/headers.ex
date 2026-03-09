defmodule Appwrite.Types.Client.Headers do
  @moduledoc """
  Type alias for an HTTP headers map used by the Appwrite client.

  Represents a flat map of string header names to string values that
  is merged into every outgoing HTTP request alongside the base client
  configuration headers.

  ## Example

      %{
        "content-type"  => "application/json",
        "x-appwrite-project" => "my-project-id"
      }
  """

  @type t :: %{required(String.t()) => String.t()}
end
