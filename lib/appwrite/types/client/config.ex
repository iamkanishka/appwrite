
defmodule Appwrite.Types.Client.Config do
  @moduledoc """
  A headers structure representing a key-value pair with string keys and values.
  """
  @type t :: %{required(String.t()) => String.t()}
end