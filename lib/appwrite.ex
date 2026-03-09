defmodule Appwrite do
  @moduledoc """
  Elixir SDK for the [Appwrite](https://appwrite.io) backend-as-a-service platform.

  ## Configuration

  Add the following to your `config/config.exs` (or per-environment config file):

      config :appwrite,
        project_id: "your_project_id",
        secret:     "your_api_key",
        root_uri:   "https://cloud.appwrite.io/v1"

  ## Services

  | Module | Description |
  |---|---|
  | `Appwrite.Services.Accounts` | User authentication & account management |
  | `Appwrite.Services.Avatars` | Avatars, flags, favicons, QR codes |
  | `Appwrite.Services.Database` | Document database |
  | `Appwrite.Services.Functions` | Cloud function executions |
  | `Appwrite.Services.GraphQL` | GraphQL queries and mutations |
  | `Appwrite.Services.Health` | Server health checks |
  | `Appwrite.Services.Locale` | Locale, country, and currency data |
  | `Appwrite.Services.Messaging` | Push/SMS/email topic messaging |
  | `Appwrite.Services.Storage` | File storage and retrieval |
  | `Appwrite.Services.Teams` | Team and membership management |

  ## Utilities

  - `Appwrite.Utils.Query` — build query strings for filtering and pagination
  - `Appwrite.Utils.Permission` — generate permission strings
  - `Appwrite.Utils.Role` — generate role strings
  - `Appwrite.Utils.Id` — generate unique resource IDs
  """

  defmodule MissingProjectIdError do
    @moduledoc """
    Raised when `:project_id` is not set in the application config.
    """
    defexception message: """
                 The `project_id` config key is required for all Appwrite API calls.
                 Add it to your config file:

                     config :appwrite, project_id: "your_project_id"

                 Use environment-specific files (config/dev.exs, config/prod.exs)
                 to supply different values per environment.
                 """
  end

  defmodule MissingSecretError do
    @moduledoc """
    Raised when `:secret` (API key) is not set in the application config.
    """
    defexception message: """
                 The `secret` config key is required for all Appwrite API calls.
                 Add it to your config file:

                     config :appwrite, secret: "your_api_key"

                 Use environment-specific files (config/dev.exs, config/prod.exs)
                 to supply different values per environment.
                 """
  end

  defmodule MissingRootUriError do
    @moduledoc """
    Raised when `:root_uri` is not set in the application config.
    """
    defexception message: """
                 The `root_uri` config key is required to specify which Appwrite
                 instance to connect to. Add it to your config file:

                     config :appwrite, root_uri: "https://cloud.appwrite.io/v1"

                 For self-hosted instances replace the URL with your own endpoint.
                 Use environment-specific files (config/dev.exs, config/prod.exs)
                 to supply different values per environment.
                 """
  end
end
