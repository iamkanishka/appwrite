defmodule Appwrite.Utils.Query do
  @moduledoc """
  Builds Appwrite query strings for filtering, sorting, selecting, and
  paginating database documents.

  Every function returns a JSON-encoded string ready to pass in the
  `queries` list of any listing call.

  ## Quick reference

      alias Appwrite.Utils.Query

      Query.equal("status", "active")
      Query.between("age", 18, 65)
      Query.order_desc("created_at")
      Query.limit(20)
      Query.cursor_after("doc_abc")
      Query.select(["title", "body"])

      # Logical nesting
      Query.logical_or([Query.equal("role", "admin"), Query.equal("role", "owner")])

  > #### `or` / `and` are reserved {: .info}
  > Elixir reserves `or` and `and` as keywords, so the logical combinators are
  > named `logical_or/1` and `logical_and/1`.
  """

  # ---------------------------------------------------------------------------
  # Types
  # ---------------------------------------------------------------------------

  @type scalar :: String.t() | number() | boolean()
  @type query_value :: scalar() | [scalar() | map()]
  @type t :: String.t()

  # ---------------------------------------------------------------------------
  # Core builder
  # ---------------------------------------------------------------------------

  @doc """
  Low-level query constructor.

  Builds a JSON query string from a method name, an optional attribute, and
  optional values. `nil` fields are omitted from the output so the payload
  stays minimal.

  ## Examples

      iex> Appwrite.Utils.Query.new("equal", "name", "John")
      ~s({"method":"equal","attribute":"name","values":["John"]})

      iex> Appwrite.Utils.Query.new("limit", nil, 10)
      ~s({"method":"limit","values":[10]})

      iex> Appwrite.Utils.Query.new("isNull", "deletedAt")
      ~s({"method":"isNull","attribute":"deletedAt"})

  """
  @spec new(String.t(), String.t() | nil, query_value() | nil) :: t()
  def new(method, attribute \\ nil, values \\ nil) do
    %{method: method}
    |> put_if_present(:attribute, attribute)
    |> put_if_present(:values, wrap_values(values))
    |> Jason.encode!()
  end

  # ---------------------------------------------------------------------------
  # Comparison
  # ---------------------------------------------------------------------------

  @doc "Match documents where `attribute` equals `value` (scalar or list)."
  @spec equal(String.t(), query_value()) :: t()
  def equal(attribute, value), do: new("equal", attribute, value)

  @doc "Match documents where `attribute` is not equal to `value`."
  @spec not_equal(String.t(), query_value()) :: t()
  def not_equal(attribute, value), do: new("notEqual", attribute, value)

  @doc "Match documents where `attribute` < `value`."
  @spec less_than(String.t(), query_value()) :: t()
  def less_than(attribute, value), do: new("lessThan", attribute, value)

  @doc "Match documents where `attribute` <= `value`."
  @spec less_than_equal(String.t(), query_value()) :: t()
  def less_than_equal(attribute, value), do: new("lessThanEqual", attribute, value)

  @doc "Match documents where `attribute` > `value`."
  @spec greater_than(String.t(), query_value()) :: t()
  def greater_than(attribute, value), do: new("greaterThan", attribute, value)

  @doc "Match documents where `attribute` >= `value`."
  @spec greater_than_equal(String.t(), query_value()) :: t()
  def greater_than_equal(attribute, value), do: new("greaterThanEqual", attribute, value)

  @doc "Match documents where `start_value <= attribute <= end_value` (inclusive)."
  @spec between(String.t(), scalar(), scalar()) :: t()
  def between(attribute, start_value, end_value),
    do: new("between", attribute, [start_value, end_value])

  # ---------------------------------------------------------------------------
  # Null checks
  # ---------------------------------------------------------------------------

  @doc "Match documents where `attribute` is `null`."
  @spec is_null(String.t()) :: t()
  def is_null(attribute), do: new("isNull", attribute)

  @doc "Match documents where `attribute` is not `null`."
  @spec is_not_null(String.t()) :: t()
  def is_not_null(attribute), do: new("isNotNull", attribute)

  # ---------------------------------------------------------------------------
  # String matching
  # ---------------------------------------------------------------------------

  @doc "Full-text search on `attribute` for `value`."
  @spec search(String.t(), String.t()) :: t()
  def search(attribute, value), do: new("search", attribute, value)

  @doc "Match documents where `attribute` starts with `value`."
  @spec starts_with(String.t(), String.t()) :: t()
  def starts_with(attribute, value), do: new("startsWith", attribute, value)

  @doc "Match documents where `attribute` ends with `value`."
  @spec ends_with(String.t(), String.t()) :: t()
  def ends_with(attribute, value), do: new("endsWith", attribute, value)

  @doc "Match documents where `attribute` contains `value` (string or array attribute)."
  @spec contains(String.t(), String.t() | [String.t()]) :: t()
  def contains(attribute, value), do: new("contains", attribute, value)

  # ---------------------------------------------------------------------------
  # Sorting
  # ---------------------------------------------------------------------------

  @doc "Sort results by `attribute` ascending."
  @spec order_asc(String.t()) :: t()
  def order_asc(attribute), do: new("orderAsc", attribute)

  @doc "Sort results by `attribute` descending."
  @spec order_desc(String.t()) :: t()
  def order_desc(attribute), do: new("orderDesc", attribute)

  # ---------------------------------------------------------------------------
  # Pagination
  # ---------------------------------------------------------------------------

  @doc "Return at most `limit` documents."
  @spec limit(non_neg_integer()) :: t()
  def limit(limit), do: new("limit", nil, limit)

  @doc "Skip the first `offset` documents."
  @spec offset(non_neg_integer()) :: t()
  def offset(offset), do: new("offset", nil, offset)

  @doc "Return documents **after** the given document ID (cursor-based pagination)."
  @spec cursor_after(String.t()) :: t()
  def cursor_after(document_id), do: new("cursorAfter", nil, document_id)

  @doc "Return documents **before** the given document ID."
  @spec cursor_before(String.t()) :: t()
  def cursor_before(document_id), do: new("cursorBefore", nil, document_id)

  # ---------------------------------------------------------------------------
  # Projection
  # ---------------------------------------------------------------------------

  @doc "Return only the listed attribute names in each document."
  @spec select([String.t()]) :: t()
  def select(attributes) when is_list(attributes), do: new("select", nil, attributes)

  # ---------------------------------------------------------------------------
  # Logical operators
  # ---------------------------------------------------------------------------

  @doc """
  Combine queries with logical OR.

  Each element must be a query string produced by any function in this module.

  ## Example

      Query.logical_or([Query.equal("role", "admin"), Query.equal("role", "owner")])

  """
  @spec logical_or([t()]) :: t()
  def logical_or(queries) when is_list(queries) do
    new("or", nil, Enum.map(queries, &Jason.decode!/1))
  end

  @doc """
  Combine queries with logical AND.

  Each element must be a query string produced by any function in this module.

  ## Example

      Query.logical_and([Query.equal("active", true), Query.greater_than("age", 18)])

  """
  @spec logical_and([t()]) :: t()
  def logical_and(queries) when is_list(queries) do
    new("and", nil, Enum.map(queries, &Jason.decode!/1))
  end

  # ---------------------------------------------------------------------------
  # Private helpers
  # ---------------------------------------------------------------------------

  # Wraps a scalar into a single-element list; passes lists through unchanged;
  # returns nil for nil so the key can be omitted from the payload.
  @spec wrap_values(query_value() | nil) :: [term()] | nil
  defp wrap_values(nil), do: nil
  defp wrap_values(v) when is_list(v), do: v
  defp wrap_values(v), do: [v]

  # Only adds the key when the value is non-nil, keeping encoded payloads minimal.
  @spec put_if_present(map(), atom(), term()) :: map()
  defp put_if_present(map, _key, nil), do: map
  defp put_if_present(map, key, value), do: Map.put(map, key, value)
end
