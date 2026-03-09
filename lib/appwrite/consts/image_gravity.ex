defmodule Appwrite.Consts.ImageGravity do
  @moduledoc """
  Image crop/positioning gravity values for the Appwrite Storage preview endpoint.

  | Gravity      | Value           |
  |--------------|-----------------|
  | Center       | `"center"`      |
  | Top-left     | `"top-left"`    |
  | Top          | `"top"`         |
  | Top-right    | `"top-right"`   |
  | Left         | `"left"`        |
  | Right        | `"right"`       |
  | Bottom-left  | `"bottom-left"` |
  | Bottom       | `"bottom"`      |
  | Bottom-right | `"bottom-right"`|
  """

  use Appwrite.Consts.Behaviour,
    values: ~w(center top-left top top-right left right bottom-left bottom bottom-right),
    name: "image gravity"
end
