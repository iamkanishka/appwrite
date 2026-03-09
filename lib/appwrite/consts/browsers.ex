defmodule Appwrite.Consts.Browser do
  @moduledoc """
  Browser type codes used by the Appwrite Avatars service.

  | Browser                | Code   |
  |------------------------|--------|
  | Avant Browser          | `"aa"` |
  | Android WebView Beta   | `"an"` |
  | Google Chrome          | `"ch"` |
  | Google Chrome iOS      | `"ci"` |
  | Google Chrome Mobile   | `"cm"` |
  | Chromium               | `"cr"` |
  | Mozilla Firefox        | `"ff"` |
  | Safari                 | `"sf"` |
  | Mobile Safari          | `"mf"` |
  | Microsoft Edge         | `"ps"` |
  | Microsoft Edge iOS     | `"oi"` |
  | Opera Mini             | `"om"` |
  | Opera                  | `"op"` |
  | Opera Next             | `"on"` |
  """

  use Appwrite.Consts.Behaviour,
    values: ~w(aa an ch ci cm cr ff sf mf ps oi om op on),
    name:   "browser"
end
