defmodule CreditCard do
  @moduledoc """
  Provides constants and validation functions for different credit card types.

  This module defines the allowed credit card types and provides helper functions
  to validate them, ensuring only recognized credit card types are used within the application.
  """

  @american_express "amex"
  @argencard "argencard"
  @cabal "cabal"
  @cencosud "cencosud"
  @diners_club "diners"
  @discover "discover"
  @elo "elo"
  @hipercard "hipercard"
  @jcb "jcb"
  @mastercard "mastercard"
  @naranja "naranja"
  @tarjeta_shopping "targeta-shopping"
  @union_china_pay "union-china-pay"
  @visa "visa"
  @mir "mir"
  @maestro "maestro"

  @all_credit_cards [
    @american_express,
    @argencard,
    @cabal,
    @cencosud,
    @diners_club,
    @discover,
    @elo,
    @hipercard,
    @jcb,
    @mastercard,
    @naranja,
    @tarjeta_shopping,
    @union_china_pay,
    @visa,
    @mir,
    @maestro
  ]

  @doc """
  Guard clause to check if a given credit card type is valid.

  ## Examples

      iex> CreditCard.valid_credit_card("amex")
      true

      iex> CreditCard.valid_credit_card("unknown")
      false
  """
  defguard valid_credit_card(card) when card in @all_credit_cards

  @doc """
  Validates the given `credit_card` type and returns `{:ok, credit_card}` if it is valid,
  or `{:error, "Invalid credit card type"}` otherwise.

  ## Examples

      iex> CreditCard.validate_credit_card("amex")
      {:ok, "amex"}

      iex> CreditCard.validate_credit_card("unknown")
      {:error, "Invalid credit card type"}
  """
  def validate_credit_card(card) when valid_credit_card(card), do: {:ok, card}
  def validate_credit_card(_card), do: {:error, "Invalid credit card type"}

  @doc """
  Returns `true` if the given `credit_card` type is valid, otherwise `false`.

  ## Examples

      iex> CreditCard.is_valid_credit_card?("mastercard")
      true

      iex> CreditCard.is_valid_credit_card?("unknown")
      false
  """
  def is_valid_credit_card?(card), do: card in @all_credit_cards

  @doc """
  Validates the given `credit_card` type and returns it if it is valid. Raises an
  `ArgumentError` if the `credit_card` type is invalid.

  ## Examples

      iex> CreditCard.validate_credit_card!("visa")
      "visa"

      iex> CreditCard.validate_credit_card!("unknown")
      ** (ArgumentError) Invalid credit card type: "unknown"
  """
  def validate_credit_card!(card) do
    if card in @all_credit_cards do
      card
    else
      raise ArgumentError, "Invalid credit card type: #{inspect(card)}"
    end
  end
end
