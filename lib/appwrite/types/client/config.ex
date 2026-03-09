defmodule Appwrite.Types.Client.Config do
  @moduledoc """
  Type alias for the Appwrite client configuration map.

  Represents a flat map of string configuration keys to string values,
  used to store settings such as the project ID, endpoint, and custom
  headers that are applied to every API request.

  ## Example

      %{
        "project"  => "my-project-id",
        "endpoint" => "https://cloud.appwrite.io/v1",
        "x-sdk-name" => "Elixir"
      }
  """

  @type t :: %{required(String.t()) => String.t()}
end
