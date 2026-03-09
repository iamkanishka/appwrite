defmodule Appwrite.Consts.CreditCard do
  @moduledoc """
  Credit card type codes used by the Appwrite Avatars service.

  | Card                   | Code                  |
  |------------------------|-----------------------|
  | American Express       | `"amex"`              |
  | Argencard              | `"argencard"`         |
  | Cabal                  | `"cabal"`             |
  | Cencosud               | `"cencosud"`          |
  | Diners Club            | `"diners"`            |
  | Discover               | `"discover"`          |
  | Elo                    | `"elo"`               |
  | Hipercard              | `"hipercard"`         |
  | JCB                    | `"jcb"`               |
  | Mastercard             | `"mastercard"`        |
  | Naranja                | `"naranja"`           |
  | Tarjeta Shopping       | `"targeta-shopping"`  |
  | Union China Pay        | `"union-china-pay"`   |
  | Visa                   | `"visa"`              |
  | Mir                    | `"mir"`               |
  | Maestro                | `"maestro"`           |
  """

  use Appwrite.Consts.Behaviour,
    values: ~w(amex argencard cabal cencosud diners discover elo hipercard
               jcb mastercard naranja targeta-shopping union-china-pay
               visa mir maestro),
    name:   "credit card"
end
