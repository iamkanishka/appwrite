# Installation

Appwrite is published on [Hex](https://hex.pm/packages/appwrite). Add it to your list of dependencies in `mix.exs`:
```elixir
# mix.exs
def deps do
  [
    {:appwrite, "~> 0.2.0"}
  ]
end
```

Then fetch your dependencies:
```sh
mix deps.get
```

## Configuration

Add the following to your `config/config.exs` (or the appropriate environment-specific config file):
```elixir
# config/config.exs
config :appwrite,
  project_id: "your_project_id",
  secret:     "your_api_key",
  root_uri:   "https://cloud.appwrite.io/v1"
```

All three keys are required. The SDK will raise a descriptive error at runtime if any are missing.

- `project_id` — found in your Appwrite Console under **Project Settings**
- `secret`     — an API key created in **Appwrite Console → API Keys**
- `root_uri`   — `https://cloud.appwrite.io/v1` for Appwrite Cloud, or your self-hosted endpoint

## Usage
```elixir
# Fetch the current user
{:ok, user} = Appwrite.Services.Accounts.get()

# List documents in a collection
{:ok, docs} = Appwrite.Services.Database.list_documents("my_db_id", "my_collection_id")

# Upload a file
{:ok, file} = Appwrite.Services.Storage.create_file("my_bucket_id", nil, file_data, nil)
```

For full API documentation see [hexdocs.pm/appwrite](https://hexdocs.pm/appwrite).