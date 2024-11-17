defmodule Appwrite.Consts.ImageGravity do
  @moduledoc """
  Provides constants and validation functions for image gravity (positioning) values.

  This module defines various image gravity options, such as `center`, `top-left`, `bottom-right`, etc.
  Helper functions are included to validate these gravity values, ensuring only recognized positioning options are used.
  """

  @center "center"
  @top_left "top-left"
  @top "top"
  @top_right "top-right"
  @left "left"
  @right "right"
  @bottom_left "bottom-left"
  @bottom "bottom"
  @bottom_right "bottom-right"

  @all_gravities [
    @center,
    @top_left,
    @top,
    @top_right,
    @left,
    @right,
    @bottom_left,
    @bottom,
    @bottom_right
  ]



  @doc """
  Guard clause to check if a given `image gravity` is a valid  image gravity code.

  ## Examples

      iex> ImageGravity.valid_gravity("center")
      true

      iex> ImageGravity.valid_gravity("down_right")
      false
  """
  @spec valid_gravity(String.t()) :: boolean()
  defguard valid_gravity(image_gravity) when image_gravity in @all_gravities



  @doc """
  Returns true if the given `gravity` is a valid image gravity value.

  ## Examples

      iex> ImageGravity.is_valid_gravity?("top-left")
      true

      iex> ImageGravity.is_valid_gravity?("middle")
      false
  """
  @spec is_valid_gravity?(String.t()) :: boolean()
  def is_valid_gravity?(gravity), do: gravity in @all_gravities

  @doc """
  Validates the given `gravity` and returns `{:ok, gravity}` if it is valid,
  or `{:error, "Invalid image gravity"}` otherwise.

  ## Examples

      iex> ImageGravity.validate_gravity("top-right")
      {:ok, "top-right"}

      iex> ImageGravity.validate_gravity("middle")
      {:error, "Invalid image gravity"}
  """
  @spec validate_gravity(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def validate_gravity(gravity) when gravity in @all_gravities, do: {:ok, gravity}
  def validate_gravity(_gravity), do: {:error, "Invalid image gravity"}

  @doc """
  Returns the given `gravity` if it is valid. Raises an `ArgumentError`
  if the `gravity` is invalid.

  ## Examples

      iex> ImageGravity.validate_gravity!("center")
      "center"

      iex> ImageGravity.validate_gravity!("middle")
      ** (ArgumentError) Invalid image gravity: "middle"
  """
  @spec validate_gravity!(String.t()) :: String.t()
  def validate_gravity!(gravity) do
    if gravity in @all_gravities do
      gravity
    else
      raise ArgumentError, "Invalid image gravity: #{inspect(gravity)}"
    end
  end
end
