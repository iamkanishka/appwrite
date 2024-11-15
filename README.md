# Appwrite

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `appwrite` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:appwrite, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/appwrite>.

## Const with validation

Helper modules to for the following resources

AuthenticationFactor: Defines supported authentication factors such as email, phone, and TOTP.
AuthenticatorType: Specifies the available authenticator types (currently just TOTP).
Browser: Lists various browser types with associated shorthand values.
CreditCard: Covers a wide range of credit card types such as American Express, Visa, MasterCard, etc.
ExecutionMethod: Includes HTTP methods like GET, POST, PUT, DELETE, etc.
Flag: Represents various country flags using two-letter country codes.
ImageFormat: Lists common image formats such as JPG, PNG, and WebP.
ImageGravity: Defines different image positioning values (e.g., center, top-left, bottom-right).
OAuthProvider: Covers a wide list of OAuth providers like Google, GitHub, PayPal, and many others.

## ID Module

Helper module to generate ID strings for resources. This module provides functions
to generate unique ID strings, either based on a timestamp or with custom or Appwrite-like generation methods.

hex_timestamp/0:

Generates a hexadecimal timestamp based on the current time in seconds and milliseconds (equivalent to #hexTimestamp in TypeScript).
Uses :os.system_time(:seconds) for the timestamp and :os.system_time(:milli_seconds) for milliseconds.
custom/1:

Takes a string and returns it as is (similar to the TypeScript custom method).
unique/1:

Generates a unique ID by concatenating the hexadecimal timestamp with random padding (default of 7 digits, configurable).
Uses :rand.uniform/1 to generate random digits and append them to the base ID.

## Permission Module

Helper module for generating permission strings for resources.

Each function (read, write, create, update, delete) generates a permission string by embedding the given role in a specific permission format.
The @doc annotations provide descriptions and usage examples, making the module easy to understand and use.
Each function guards with when is_binary(role) to ensure the role is a string.

## Role Module

Helper module for generating role strings for `Permission`.

The functions any/0, user/2, users/1, guests/0, team/2, member/1, and label/1 provide specific role strings, with optional parameters where needed.
Each function is documented with @doc annotations that describe its purpose, parameters, and usage examples.
