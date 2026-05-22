defmodule Appwrite.Services.TablesDB do
  @moduledoc """
  The TablesDB service provides a structured, SQL-like data storage layer on
  top of Appwrite — separate from the document-oriented `Database` service.

  This is an entirely new Appwrite Cloud service added in v1.0.0.

  TablesDB exposes tables, columns, and rows with typed constraints, making it
  suitable for workloads that require strict schemas and relational-style queries.

  ## Hierarchy

      Project
      └── Table
          ├── Column (schema definition)
          └── Row (data)
  """

  use Appwrite.Services.Base

  # ────────────────────────────────────────────────
  # Tables
  # ────────────────────────────────────────────────

  @doc """
  Create a new Table.

  ## Parameters
  - `table_id` (required) – unique identifier; use `"unique()"` to auto-generate
  - `name` (required) – human-readable table name
  - `permissions` (optional) – list of permission strings
  - `document_security` (optional) – when `true`, enables per-row security
  """
  @spec create_table(String.t(), String.t(), [String.t()] | nil, boolean() | nil) ::
          {:ok, map()} | {:error, any()}
  def create_table(table_id, name, permissions \\ nil, document_security \\ nil) do
    with :ok <- require_all(table_id: table_id, name: name) do
      payload =
        %{"tableId" => table_id, "name" => name}
        |> maybe_put("permissions", permissions)
        |> maybe_put("documentSecurity", document_security)

      json_call("post", "/v1/tablesdb", payload)
    end
  end

  @doc """
  List all Tables in the project.

  ## Parameters
  - `queries` (optional)
  - `search` (optional)
  """
  @spec list_tables([String.t()] | nil, String.t() | nil) :: {:ok, map()} | {:error, any()}
  def list_tables(queries \\ nil, search \\ nil) do
    payload =
      %{}
      |> maybe_put("queries", queries)
      |> maybe_put("search", search)

    json_call("get", "/v1/tablesdb", payload)
  end

  @doc """
  Get a Table by its unique ID.

  ## Parameters
  - `table_id` (required)
  """
  @spec get_table(String.t()) :: {:ok, map()} | {:error, any()}
  def get_table(table_id) do
    with :ok <- require_all(table_id: table_id) do
      json_call("get", "/v1/tablesdb/#{table_id}", %{})
    end
  end

  @doc """
  Update a Table's name and/or permissions.

  ## Parameters
  - `table_id` (required)
  - `name` (required) – new table name
  - `permissions` (optional)
  - `document_security` (optional)
  """
  @spec update_table(String.t(), String.t(), [String.t()] | nil, boolean() | nil) ::
          {:ok, map()} | {:error, any()}
  def update_table(table_id, name, permissions \\ nil, document_security \\ nil) do
    with :ok <- require_all(table_id: table_id, name: name) do
      payload =
        %{"name" => name}
        |> maybe_put("permissions", permissions)
        |> maybe_put("documentSecurity", document_security)

      json_call("put", "/v1/tablesdb/#{table_id}", payload)
    end
  end

  @doc """
  Delete a Table by its unique ID.

  ## Parameters
  - `table_id` (required)
  """
  @spec delete_table(String.t()) :: {:ok, map()} | {:error, any()}
  def delete_table(table_id) do
    with :ok <- require_all(table_id: table_id) do
      json_call("delete", "/v1/tablesdb/#{table_id}", %{})
    end
  end

  # ────────────────────────────────────────────────
  # Columns
  # ────────────────────────────────────────────────

  @doc """
  Create a new Column in a Table.

  ## Parameters
  - `table_id` (required)
  - `column_id` (required) – unique column key
  - `type` (required) – data type: `"string"`, `"integer"`, `"float"`,
    `"boolean"`, `"datetime"`, `"email"`, `"url"`, `"ip"`, `"enum"`, etc.
  - `opts` keyword list:
    - `:required` – boolean (default `false`)
    - `:default` – default value
    - `:array` – when `true`, stores a list of the given type
    - `:size` – max length for string columns
    - `:min` – minimum value for numeric columns
    - `:max` – maximum value for numeric columns
    - `:elements` – list of allowed values for enum columns
    - `:format` – format hint (e.g. `"email"`, `"url"`, `"ip"`)
  """
  @spec create_column(String.t(), String.t(), String.t(), keyword()) ::
          {:ok, map()} | {:error, any()}
  def create_column(table_id, column_id, type, opts \\ []) do
    with :ok <- require_all(table_id: table_id, column_id: column_id, type: type) do
      payload =
        %{"columnId" => column_id, "type" => type}
        |> maybe_put("required", opts[:required])
        |> maybe_put("default", opts[:default])
        |> maybe_put("array", opts[:array])
        |> maybe_put("size", opts[:size])
        |> maybe_put("min", opts[:min])
        |> maybe_put("max", opts[:max])
        |> maybe_put("elements", opts[:elements])
        |> maybe_put("format", opts[:format])

      json_call("post", "/v1/tablesdb/#{table_id}/columns", payload)
    end
  end

  @doc """
  List all Columns for a Table.

  ## Parameters
  - `table_id` (required)
  - `queries` (optional)
  """
  @spec list_columns(String.t(), [String.t()] | nil) :: {:ok, map()} | {:error, any()}
  def list_columns(table_id, queries \\ nil) do
    with :ok <- require_all(table_id: table_id) do
      payload = maybe_put(%{}, "queries", queries)
      json_call("get", "/v1/tablesdb/#{table_id}/columns", payload)
    end
  end

  @doc """
  Get a Column by its unique ID.

  ## Parameters
  - `table_id` (required)
  - `column_id` (required)
  """
  @spec get_column(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def get_column(table_id, column_id) do
    with :ok <- require_all(table_id: table_id, column_id: column_id) do
      json_call("get", "/v1/tablesdb/#{table_id}/columns/#{column_id}", %{})
    end
  end

  @doc """
  Update a Column — change required/default/size constraints.

  Note: the column `type` cannot be changed after creation.

  ## Parameters
  - `table_id` (required)
  - `column_id` (required)
  - `opts` keyword list – any subset of the fields from `create_column/4`
  """
  @spec update_column(String.t(), String.t(), keyword()) :: {:ok, map()} | {:error, any()}
  def update_column(table_id, column_id, opts \\ []) do
    with :ok <- require_all(table_id: table_id, column_id: column_id) do
      payload =
        %{}
        |> maybe_put("required", opts[:required])
        |> maybe_put("default", opts[:default])
        |> maybe_put("size", opts[:size])
        |> maybe_put("min", opts[:min])
        |> maybe_put("max", opts[:max])
        |> maybe_put("elements", opts[:elements])

      json_call("patch", "/v1/tablesdb/#{table_id}/columns/#{column_id}", payload)
    end
  end

  @doc """
  Delete a Column by its unique ID.

  ## Parameters
  - `table_id` (required)
  - `column_id` (required)
  """
  @spec delete_column(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def delete_column(table_id, column_id) do
    with :ok <- require_all(table_id: table_id, column_id: column_id) do
      json_call("delete", "/v1/tablesdb/#{table_id}/columns/#{column_id}", %{})
    end
  end

  # ────────────────────────────────────────────────
  # Rows
  # ────────────────────────────────────────────────

  @doc """
  Create a new Row in a Table.

  ## Parameters
  - `table_id` (required)
  - `row_id` (required) – unique identifier; use `"unique()"` to auto-generate
  - `data` (optional) – map of column keys → values
  - `permissions` (optional)
  """
  @spec create_row(String.t(), String.t(), map() | nil, [String.t()] | nil) ::
          {:ok, map()} | {:error, any()}
  def create_row(table_id, row_id, data \\ nil, permissions \\ nil) do
    with :ok <- require_all(table_id: table_id, row_id: row_id) do
      payload =
        %{"rowId" => row_id}
        |> maybe_put("data", data)
        |> maybe_put("permissions", permissions)

      json_call("post", "/v1/tablesdb/#{table_id}/rows", payload)
    end
  end

  @doc """
  List Rows in a Table.

  ## Parameters
  - `table_id` (required)
  - `queries` (optional)
  """
  @spec list_rows(String.t(), [String.t()] | nil) :: {:ok, map()} | {:error, any()}
  def list_rows(table_id, queries \\ nil) do
    with :ok <- require_all(table_id: table_id) do
      payload = maybe_put(%{}, "queries", queries)
      json_call("get", "/v1/tablesdb/#{table_id}/rows", payload)
    end
  end

  @doc """
  Get a Row by its unique ID.

  ## Parameters
  - `table_id` (required)
  - `row_id` (required)
  """
  @spec get_row(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def get_row(table_id, row_id) do
    with :ok <- require_all(table_id: table_id, row_id: row_id) do
      json_call("get", "/v1/tablesdb/#{table_id}/rows/#{row_id}", %{})
    end
  end

  @doc """
  Update a Row by its unique ID.

  ## Parameters
  - `table_id` (required)
  - `row_id` (required)
  - `data` (optional) – map of column keys → new values
  - `permissions` (optional)
  """
  @spec update_row(String.t(), String.t(), map() | nil, [String.t()] | nil) ::
          {:ok, map()} | {:error, any()}
  def update_row(table_id, row_id, data \\ nil, permissions \\ nil) do
    with :ok <- require_all(table_id: table_id, row_id: row_id) do
      payload =
        %{}
        |> maybe_put("data", data)
        |> maybe_put("permissions", permissions)

      json_call("patch", "/v1/tablesdb/#{table_id}/rows/#{row_id}", payload)
    end
  end

  @doc """
  Upsert a Row (create or update atomically).

  ## Parameters
  - `table_id` (required)
  - `row_id` (required)
  - `data` (optional)
  - `permissions` (optional)
  """
  @spec upsert_row(String.t(), String.t(), map() | nil, [String.t()] | nil) ::
          {:ok, map()} | {:error, any()}
  def upsert_row(table_id, row_id, data \\ nil, permissions \\ nil) do
    with :ok <- require_all(table_id: table_id, row_id: row_id) do
      payload =
        %{}
        |> maybe_put("data", data)
        |> maybe_put("permissions", permissions)

      json_call("put", "/v1/tablesdb/#{table_id}/rows/#{row_id}", payload)
    end
  end

  @doc """
  Delete a Row by its unique ID.

  ## Parameters
  - `table_id` (required)
  - `row_id` (required)
  """
  @spec delete_row(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def delete_row(table_id, row_id) do
    with :ok <- require_all(table_id: table_id, row_id: row_id) do
      json_call("delete", "/v1/tablesdb/#{table_id}/rows/#{row_id}", %{})
    end
  end

  # ────────────────────────────────────────────────
  # Private helpers
  # ────────────────────────────────────────────────
end
