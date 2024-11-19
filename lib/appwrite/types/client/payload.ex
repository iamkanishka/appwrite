defmodule Appwrite.Types.Client.Payload do
  @moduledoc """
  A generic payload structure represented as a key-value pair with string keys and any values.
  """
  @type t :: %{required(String.t()) => any()}
end
