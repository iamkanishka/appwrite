defmodule Appwrite.Consts.ImageFormat do
  @moduledoc """
  Image output formats supported by the Appwrite Storage preview endpoint.

  | Format | Value    |
  |--------|----------|
  | JPG    | `"jpg"`  |
  | JPEG   | `"jpeg"` |
  | GIF    | `"gif"`  |
  | PNG    | `"png"`  |
  | WebP   | `"webp"` |
  """

  use Appwrite.Consts.Behaviour,
    values: ~w(jpg jpeg gif png webp),
    name: "image format"
end
