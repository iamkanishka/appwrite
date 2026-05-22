defmodule Appwrite do
  @moduledoc """
  Elixir SDK for the [Appwrite](https://appwrite.io) backend-as-a-service platform.

  ## Configuration

  Add to your `config/config.exs` (or a per-environment config file):

      config :appwrite,
        project_id: System.get_env("APPWRITE_PROJECT_ID"),
        secret:     System.get_env("APPWRITE_SECRET"),
        root_uri:   System.get_env("APPWRITE_ENDPOINT", "https://cloud.appwrite.io/v1")

  For runtime configuration (recommended in production), use `config/runtime.exs`:

      import Config

      config :appwrite,
        project_id: System.fetch_env!("APPWRITE_PROJECT_ID"),
        secret:     System.fetch_env!("APPWRITE_SECRET"),
        root_uri:   System.get_env("APPWRITE_ENDPOINT", "https://cloud.appwrite.io/v1")

  ## Services

  | Module | Description |
  |---|---|
  | `Appwrite.Services.Accounts`  | User authentication and account management |
  | `Appwrite.Services.Avatars`   | Avatars, flags, favicons, QR codes, screenshots |
  | `Appwrite.Services.Database`  | Document database with transactions |
  | `Appwrite.Services.Functions` | Cloud function executions |
  | `Appwrite.Services.GraphQL`   | GraphQL queries and mutations |
  | `Appwrite.Services.Health`    | Server health checks |
  | `Appwrite.Services.Locale`    | Locale, country, currency, and language data |
  | `Appwrite.Services.Messaging` | Push/SMS/email topic messaging |
  | `Appwrite.Services.Sites`     | Hosted web application deployments |
  | `Appwrite.Services.Storage`   | File storage and retrieval |
  | `Appwrite.Services.TablesDB`  | Structured SQL-like table/row storage |
  | `Appwrite.Services.Teams`     | Team and membership management |
  | `Appwrite.Services.Tokens`    | File access token management |

  ## Utilities

  | Module | Description |
  |---|---|
  | `Appwrite.Utils.Query`      | Build query strings for filtering and pagination |
  | `Appwrite.Utils.Permission` | Generate permission strings |
  | `Appwrite.Utils.Role`       | Generate role strings |
  | `Appwrite.Utils.Id`         | Generate unique resource IDs |

  ## Quick start

      alias Appwrite.Services.Accounts
      alias Appwrite.Utils.Id
      alias Appwrite.Utils.Permission
      alias Appwrite.Utils.Query
      alias Appwrite.Utils.Role

      # Create a user
      {:ok, user} = Accounts.create(Id.unique(), "user@example.com", "password123")

      # Email + password login
      {:ok, session} = Accounts.create_email_password_session("user@example.com", "password123")

      # List documents with a query
      alias Appwrite.Services.Database
      {:ok, docs} = Database.list_documents("db_id", "col_id", [
        Query.equal("status", "active"),
        Query.limit(20),
        Query.order_desc("created_at")
      ])

  ## Error handling

  All service functions return `{:ok, map()}` on success or `{:error, reason}` on
  failure. Network and API errors are returned as `Appwrite.Exceptions.AppwriteException`
  structs inside the `{:error, ...}` tuple.

      case Accounts.get() do
        {:ok, user}  -> IO.inspect(user["name"])
        {:error, %AppwriteException{code: 401}} -> IO.puts("Not logged in")
        {:error, reason} -> IO.inspect(reason)
      end

  """

  defmodule MissingProjectIdError do
    @moduledoc """
    Raised when `:project_id` is not set in the application config.
    """
    defexception message: """
                 The `project_id` config key is required for all Appwrite API calls.

                 Add it to your config:

                     config :appwrite, project_id: System.get_env("APPWRITE_PROJECT_ID")

                 """
  end

  defmodule MissingSecretError do
    @moduledoc """
    Raised when `:secret` (API key) is not set in the application config.
    """
    defexception message: """
                 The `secret` config key is required for all Appwrite API calls.

                 Add it to your config:

                     config :appwrite, secret: System.get_env("APPWRITE_SECRET")

                 """
  end

  defmodule MissingRootUriError do
    @moduledoc """
    Raised when `:root_uri` is not set in the application config.
    """
    defexception message: """
                 The `root_uri` config key specifies which Appwrite instance to use.

                 Add it to your config:

                     config :appwrite,
                       root_uri: System.get_env("APPWRITE_ENDPOINT", "https://cloud.appwrite.io/v1")

                 """
  end
end
