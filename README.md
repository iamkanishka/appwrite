# Appwrite Elixir SDK

[![Hex.pm](https://img.shields.io/hexpm/v/appwrite.svg)](https://hex.pm/packages/appwrite)
[![Docs](https://img.shields.io/badge/docs-hexdocs-blue.svg)](https://hexdocs.pm/appwrite)
[![CI](https://github.com/iamkanishka/appwrite/actions/workflows/ci.yml/badge.svg)](https://github.com/iamkanishka/appwrite/actions/workflows/ci.yml)
[![License](https://img.shields.io/hexpm/l/appwrite.svg)](LICENSE.txt)

Elixir client SDK for [Appwrite](https://appwrite.io) — the open-source
backend-as-a-service platform. Covers all client-facing APIs:
**Auth · Databases · TablesDB · Storage · Functions · Sites · Tokens ·
Teams · Messaging · GraphQL · Locale · Avatars · Health**.

---

## Installation

Add `appwrite` to your dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:appwrite, "~> 1.0"}
  ]
end
```

Then fetch:

```bash
mix deps.get
```

---

## Configuration

### `config/config.exs`

```elixir
config :appwrite,
  project_id: System.get_env("APPWRITE_PROJECT_ID"),
  secret:     System.get_env("APPWRITE_SECRET"),
  root_uri:   System.get_env("APPWRITE_ENDPOINT", "https://cloud.appwrite.io/v1")
```

### `config/runtime.exs` (recommended for production)

```elixir
import Config

if config_env() == :prod do
  config :appwrite,
    project_id: System.fetch_env!("APPWRITE_PROJECT_ID"),
    secret:     System.fetch_env!("APPWRITE_SECRET"),
    root_uri:   System.get_env("APPWRITE_ENDPOINT", "https://cloud.appwrite.io/v1")
end
```

> **Self-hosted Appwrite?** Set `APPWRITE_ENDPOINT` to your instance URL,
> e.g. `https://appwrite.mycompany.com/v1`.

---

## Quick start

```elixir
alias Appwrite.Services.{Accounts, Database, Storage}
alias Appwrite.Utils.{Id, Query, Permission, Role}

# Create a new user
{:ok, _user} = Accounts.create(Id.unique(), "alice@example.com", "secret123")

# Email + password login
{:ok, _session} = Accounts.create_email_password_session("alice@example.com", "secret123")

# Query documents
{:ok, result} = Database.list_documents("my-db", "posts", [
  Query.equal("published", true),
  Query.order_desc("created_at"),
  Query.limit(10)
])

# Upload a file
file_content = File.read!("report.pdf")
{:ok, file} = Storage.create_file("my-bucket", Id.unique(), %{
  "name" => "report.pdf",
  "data" => file_content,
  "type" => "application/pdf",
  "size" => byte_size(file_content)
})

# Get a download URL (unauthenticated via token)
{:ok, token} = Appwrite.Services.Tokens.create_file_token("my-bucket", file["$id"])
{:ok, url} = Storage.get_file_download("my-bucket", file["$id"], token["secret"])
```

---

## Services

| Module | Appwrite API |
|---|---|
| `Appwrite.Services.Accounts` | Auth, sessions, MFA, OAuth2, recovery |
| `Appwrite.Services.Avatars` | Avatars, flags, QR codes, screenshots |
| `Appwrite.Services.Database` | Documents, upsert, increment/decrement, transactions |
| `Appwrite.Services.Functions` | Executions (create, get, list) |
| `Appwrite.Services.GraphQL` | GraphQL query and mutation |
| `Appwrite.Services.Health` | Server health checks |
| `Appwrite.Services.Locale` | Countries, currencies, languages |
| `Appwrite.Services.Messaging` | Push/SMS/email topic subscribers |
| `Appwrite.Services.Sites` | Hosted site deployments and variables |
| `Appwrite.Services.Storage` | Files, chunked upload, preview/view/download URLs |
| `Appwrite.Services.TablesDB` | Tables, columns, rows |
| `Appwrite.Services.Teams` | Teams and memberships |
| `Appwrite.Services.Tokens` | File access tokens |

---

## Utilities

| Module | Purpose |
|---|---|
| `Appwrite.Utils.Query` | Build filter/sort/pagination query strings |
| `Appwrite.Utils.Permission` | Generate `read()`, `write()`, `create()` … strings |
| `Appwrite.Utils.Role` | Generate `any`, `user:id`, `team:id/role` … strings |
| `Appwrite.Utils.Id` | `Id.unique()` / `Id.custom("my-id")` |

### Permission + Role example

```elixir
alias Appwrite.Utils.{Permission, Role}

permissions = [
  Permission.read(Role.any()),               # public read
  Permission.create(Role.users()),           # any logged-in user can create
  Permission.update(Role.user("alice-id")),  # only alice can update
  Permission.delete(Role.team("admins"))     # admins can delete
]
```

---

## Error handling

All service functions return `{:ok, map()}` or `{:error, reason}`.
API errors are `Appwrite.Exceptions.AppwriteException` structs:

```elixir
alias Appwrite.Exceptions.AppwriteException

case Accounts.get() do
  {:ok, user} ->
    IO.puts("Hello, #{user["name"]}")

  {:error, %AppwriteException{code: 401}} ->
    IO.puts("Not authenticated")

  {:error, %AppwriteException{code: code, message: msg}} ->
    IO.puts("Appwrite error #{code}: #{msg}")

  {:error, reason} ->
    IO.inspect(reason, label: "Unexpected error")
end
```

---

## Requirements

- Elixir `~> 1.18`
- Erlang/OTP 26+

---

## License

Apache 2.0 — see [LICENSE.txt](LICENSE.txt).
