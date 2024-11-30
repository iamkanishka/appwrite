defmodule Appwrite.Utils.General do

@doc """
Generates a unique user ID using a version 4 UUID.

## Examples

    iex> generate_user_id()
    "550e8400-e29b-41d4-a716-446655440000"

The function returns a random, unique string in UUID format, suitable for identifying users in your system.

## Notes
- The generated UUID follows the version 4 standard, ensuring randomness and uniqueness.
"""
def generate_user_id do
  UUID.uuid4()
end


end
