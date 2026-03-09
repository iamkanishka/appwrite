defmodule Appwrite.Types.Preference do
  @moduledoc """
  Type alias for a user or team preferences map.

  Appwrite preferences are a plain string-keyed map of arbitrary values.
  They have no fixed shape — the schema is defined entirely by the
  application. The `t` type alias exists so other modules (e.g. `User`,
  `Team`) can reference `Appwrite.Types.Preference.t()` explicitly instead
  of using a bare `map()`.

  > #### No struct {: .info}
  > This module intentionally does **not** define a `defstruct`. Using
  > `defstruct []` would create an opaque struct that cannot hold arbitrary
  > keys, which is the opposite of what a preference map needs.

  ## Example

      %{"theme" => "dark", "locale" => "en-US", "notifications" => true}
  """

  @type t :: %{required(String.t()) => any()}
end
