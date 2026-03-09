defmodule Appwrite.Consts.Behaviour do
  @moduledoc """
  Behaviour that every Appwrite constant/enum module implements.

  Using this behaviour gives you a consistent API across all enum modules
  and lets callers write generic code against any of them:

      def validate(module, value), do: module.validate(value)

  ## Implementing

      defmodule Appwrite.Consts.MyEnum do
        use Appwrite.Consts.Behaviour, values: ~w(foo bar baz), name: "my enum"
      end
  """

  @callback valid?(String.t()) :: boolean()
  @callback validate(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  @callback validate!(String.t()) :: String.t()
  @callback values() :: [String.t()]

  @doc false
  defmacro __using__(opts) do
    values = Keyword.fetch!(opts, :values)
    name   = Keyword.fetch!(opts, :name)

    quote do
      @behaviour Appwrite.Consts.Behaviour

      # Compile-time constant — fast literal list for guards.
      @all_values unquote(values)

      # O(1) runtime lookup via MapSet for is_valid?/validate/validate!.
      @value_set MapSet.new(@all_values)

      # -----------------------------------------------------------------------
      # Guard — usable in function heads and other guards.
      # NOTE: guards must use the literal list (@all_values), not the MapSet.
      # -----------------------------------------------------------------------

      @doc """
      Guard — returns `true` when `value` is a valid #{unquote(name)}.

      Can be used in function heads:

          def handle(v) when #{__MODULE__}.valid_value(v), do: :ok
      """
      defguard valid_value(value) when value in @all_values

      # -----------------------------------------------------------------------
      # Public API
      # -----------------------------------------------------------------------

      @doc "Returns all valid #{unquote(name)} values."
      @impl Appwrite.Consts.Behaviour
      @spec values() :: [String.t()]
      def values, do: @all_values

      @doc """
      Returns `true` when `value` is a valid #{unquote(name)}, otherwise `false`.
      """
      @impl Appwrite.Consts.Behaviour
      @spec valid?(String.t()) :: boolean()
      def valid?(value), do: MapSet.member?(@value_set, value)

      @doc """
      Returns `{:ok, value}` if valid, or `{:error, "Invalid #{unquote(name)}"}`.
      """
      @impl Appwrite.Consts.Behaviour
      @spec validate(String.t()) :: {:ok, String.t()} | {:error, String.t()}
      def validate(value) when value in @all_values, do: {:ok, value}
      def validate(_value), do: {:error, "Invalid #{unquote(name)}"}

      @doc """
      Returns `value` if valid. Raises `ArgumentError` otherwise.
      """
      @impl Appwrite.Consts.Behaviour
      @spec validate!(String.t()) :: String.t()
      def validate!(value) when value in @all_values, do: value
      def validate!(value),
        do: raise(ArgumentError, "Invalid #{unquote(name)}: #{inspect(value)}")

      defoverridable [valid?: 1, validate: 1, validate!: 1, values: 0]
    end
  end
end
