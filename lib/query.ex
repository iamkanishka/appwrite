defmodule Appwrite.Query do
  @moduledoc """
  A helper module to generate query strings for Appwrite filters.

  This module provides functions to construct queries for filtering, sorting, and limiting resources
  in an Appwrite database.

  Each function returns a JSON string representation of the query.
  """

  @type query_types_single :: String.t() | number() | boolean()
  @type query_types_list :: [String.t() | number() | boolean() | map()]
  @type query_types :: query_types_single | query_types_list
  @type attributes_types :: String.t() | [String.t()]

  @doc """
  Create a query with the given method, attribute, and values.

  ## Examples

      iex> Appwrite.Query.new("equal", "name", "John")
      "{\"method\":\"equal\",\"attribute\":\"name\",\"values\":[\"John\"]}"
  """
  @spec new(String.t(), attributes_types() | nil, query_types() | nil) :: String.t()
  def new(method, attribute \\ nil, values \\ nil) do
    query =
      %{
        method: method,
        attribute: attribute,
        values:
          cond do
            is_list(values) -> values
            not is_nil(values) -> [values]
            true -> nil
          end
      }
      |> Enum.reject(fn {_key, value} -> is_nil(value) end)
      |> Map.new()

    Jason.encode!(query)
  end

  @doc """
  Filter resources where attribute is equal to the value.
  """
  @spec equal(String.t(), query_types()) :: String.t()
  def equal(attribute, value), do: new("equal", attribute, value)

  @doc """
  Filter resources where attribute is not equal to the value.
  """
  @spec not_equal(String.t(), query_types()) :: String.t()
  def not_equal(attribute, value), do: new("notEqual", attribute, value)

  @doc """
  Filter resources where attribute is less than the value.
  """
  @spec less_than(String.t(), query_types()) :: String.t()
  def less_than(attribute, value), do: new("lessThan", attribute, value)

  @doc """
  Filter resources where attribute is less than or equal to the value.
  """
  @spec less_than_equal(String.t(), query_types()) :: String.t()
  def less_than_equal(attribute, value), do: new("lessThanEqual", attribute, value)

  @doc """
  Filter resources where attribute is greater than the value.
  """
  @spec greater_than(String.t(), query_types()) :: String.t()
  def greater_than(attribute, value), do: new("greaterThan", attribute, value)

  @doc """
  Filter resources where attribute is greater than or equal to the value.
  """
  @spec greater_than_equal(String.t(), query_types()) :: String.t()
  def greater_than_equal(attribute, value), do: new("greaterThanEqual", attribute, value)

  @doc """
  Filter resources where attribute is null.
  """
  @spec is_null(String.t()) :: String.t()
  def is_null(attribute), do: new("isNull", attribute)

  @doc """
  Filter resources where attribute is not null.
  """
  @spec is_not_null(String.t()) :: String.t()
  def is_not_null(attribute), do: new("isNotNull", attribute)

  @doc """
  Filter resources where attribute is between the start and end values (inclusive).
  """
  @spec between(String.t(), query_types_single(), query_types_single()) :: String.t()
  def between(attribute, start_value, end_value),
    do: new("between", attribute, [start_value, end_value])

  @doc """
  Filter resources where attribute starts with the value.
  """
  @spec starts_with(String.t(), String.t()) :: String.t()
  def starts_with(attribute, value), do: new("startsWith", attribute, value)

  @doc """
  Filter resources where attribute ends with the value.
  """
  @spec ends_with(String.t(), String.t()) :: String.t()
  def ends_with(attribute, value), do: new("endsWith", attribute, value)

  @doc """
  Specify which attributes should be returned by the API call.
  """
  @spec select([String.t()]) :: String.t()
  def select(attributes), do: new("select", nil, attributes)

  @doc """
  Filter resources by searching an attribute for a value.
  """
  @spec search(String.t(), String.t()) :: String.t()
  def search(attribute, value), do: new("search", attribute, value)

  @doc """
  Sort results by attribute descending.
  """
  @spec order_desc(String.t()) :: String.t()
  def order_desc(attribute), do: new("orderDesc", attribute)

  @doc """
  Sort results by attribute ascending.
  """
  @spec order_asc(String.t()) :: String.t()
  def order_asc(attribute), do: new("orderAsc", attribute)

  @doc """
  Return results after the specified document ID.
  """
  @spec cursor_after(String.t()) :: String.t()
  def cursor_after(document_id), do: new("cursorAfter", nil, document_id)

  @doc """
  Return results before the specified document ID.
  """
  @spec cursor_before(String.t()) :: String.t()
  def cursor_before(document_id), do: new("cursorBefore", nil, document_id)

  @doc """
  Limit the number of results returned.
  """
  @spec limit(non_neg_integer()) :: String.t()
  def limit(limit), do: new("limit", nil, limit)

  @doc """
  Skip the first `offset` number of results.
  """
  @spec offset(non_neg_integer()) :: String.t()
  def offset(offset), do: new("offset", nil, offset)

  @doc """
  Filter resources where attribute contains the specified value(s).
  """
  @spec contains(String.t(), String.t() | [String.t()]) :: String.t()
  def contains(attribute, value), do: new("contains", attribute, value)




  # The issue arises because or and and are reserved keywords in Elixir.
  # You cannot use them directly as function names. To fix this, rename these functions to avoid using reserved keywords.
  # For example, you could use logical_or and logical_and instead

  # @doc """
  # Combine multiple queries using logical OR.
  # """
  # @spec or([String.t()]) :: String.t()
  # @derive Jason.Encoder
  # def or(queries), do: new("or", nil, Enum.map(queries, &Jason.decode!(&1)))

  # @doc """
  # Combine multiple queries using logical AND.
  # """
  # @spec and([String.t()]) :: String.t()
  # @derive Jason.Encoder
  # def and(queries), do: new("and", nil, Enum.map(queries, &Jason.decode!(&1)))

  @doc """
  Combine multiple queries using logical OR.
  """
  @spec logical_or([String.t()]) :: String.t()
  def logical_or(queries), do: new("or", nil, Enum.map(queries, &Jason.decode!(&1)))

  @doc """
  Combine multiple queries using logical AND.
  """
  @spec logical_and([String.t()]) :: String.t()
  def logical_and(queries), do: new("and", nil, Enum.map(queries, &Jason.decode!(&1)))
end
