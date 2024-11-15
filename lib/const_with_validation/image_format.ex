defmodule ImageFormat do
  @moduledoc """
  Provides constants and validation functions for image formats.

  This module defines the image formats supported by the system, such as JPG, JPEG, GIF, PNG, and WebP.
  Helper functions are included to validate these formats, ensuring only recognized image formats are used.
  """

  @jpg "jpg"
  @jpeg "jpeg"
  @gif "gif"
  @png "png"
  @webp "webp"

  @all_formats [
    @jpg,
    @jpeg,
    @gif,
    @png,
    @webp
  ]

  @doc """
  Returns true if the given `format` is a valid image format.

  ## Examples

      iex> ImageFormat.is_valid_format?("jpg")
      true

      iex> ImageFormat.is_valid_format?("bmp")
      false
  """
  def is_valid_format?(format), do: format in @all_formats

  @doc """
  Validates the given `format` and returns `{:ok, format}` if it is valid,
  or `{:error, "Invalid image format"}` otherwise.

  ## Examples

      iex> ImageFormat.validate_format("png")
      {:ok, "png"}

      iex> ImageFormat.validate_format("bmp")
      {:error, "Invalid image format"}
  """
  def validate_format(format) when format in @all_formats, do: {:ok, format}
  def validate_format(_format), do: {:error, "Invalid image format"}

  @doc """
  Returns the given `format` if it is valid. Raises an `ArgumentError`
  if the `format` is invalid.

  ## Examples

      iex> ImageFormat.validate_format!("jpg")
      "jpg"

      iex> ImageFormat.validate_format!("bmp")
      ** (ArgumentError) Invalid image format: "bmp"
  """
  def validate_format!(format) do
    if format in @all_formats do
      format
    else
      raise ArgumentError, "Invalid image format: #{inspect(format)}"
    end
  end
end
