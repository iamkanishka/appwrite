# Configuration

## Required keys

| Key | Description |
|---|---|
| `project_id` | Your Appwrite project ID |
| `secret` | Your Appwrite API key |
| `root_uri` | Appwrite endpoint (default: `https://cloud.appwrite.io/v1`) |

## Compile-time config

Add to `config/config.exs`:

```elixir
config :appwrite,
  project_id: System.get_env("APPWRITE_PROJECT_ID"),
  secret:     System.get_env("APPWRITE_SECRET"),
  root_uri:   System.get_env("APPWRITE_ENDPOINT", "https://cloud.appwrite.io/v1")
```

## Runtime config (recommended for production)

In `config/runtime.exs`:

```elixir
import Config

if config_env() == :prod do
  config :appwrite,
    project_id: System.fetch_env!("APPWRITE_PROJECT_ID"),
    secret:     System.fetch_env!("APPWRITE_SECRET"),
    root_uri:   System.get_env("APPWRITE_ENDPOINT", "https://cloud.appwrite.io/v1")
end
```

## Test config

In `config/test.exs`:

```elixir
import Config

config :appwrite,
  project_id: System.get_env("APPWRITE_TEST_PROJECT_ID", "test-project"),
  secret:     System.get_env("APPWRITE_TEST_SECRET", "test-secret"),
  root_uri:   System.get_env("APPWRITE_TEST_ENDPOINT", "https://cloud.appwrite.io/v1")
```

## Self-hosted Appwrite

Set `root_uri` to your own endpoint:

```elixir
config :appwrite,
  root_uri: "https://appwrite.mycompany.com/v1"
```
