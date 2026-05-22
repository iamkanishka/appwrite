# Changelog

All notable changes to this project will be documented in this file.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] — 2026-05-20

### Breaking changes

- **`Appwrite.Utils.General`** — `generate_unique_id/0` now uses Erlang's
  `:crypto.strong_rand_bytes/1` instead of the `:uuid` library. The returned
  format is identical (UUID v4 string) but the `:uuid` dependency is no longer
  required. Remove `{:uuid, …}` from your deps if it was added solely for this SDK.
- **`Storage.create_file/5`** — the `file` argument is now a map
  `%{"name" => ..., "data" => binary, "type" => ..., "size" => ...}` instead of
  a raw binary. See the updated `@doc` for details.
- **`Storage.get_file_preview/3`** — opts moved to a keyword list (third arg).
- Filename `o-auth_provider.ex` renamed to `oauth_provider.ex` (no functional change).
- Filename `Id.ex` renamed to `id.ex` (no functional change).

### Added

- `Appwrite.Services.Sites` — new service: site/deployment/variable/log management.
- `Appwrite.Services.TablesDB` — new service: table/column/row CRUD + upsert.
- `Appwrite.Services.Tokens` — new service: file access token management.
- `Accounts.update_recovery/3` — completes the password-reset flow (`PUT /account/recovery`).
- `Accounts.create_jwt/1` — now accepts optional `duration` parameter.
- `Accounts.list_logs/2` — now accepts optional `total` parameter.
- `Accounts.list_identities/2` — now accepts optional `total` parameter.
- `Database.upsert_document/6` — atomic create-or-update (`PUT` endpoint).
- `Database.increment_document_attribute/7` — atomic numeric increment.
- `Database.decrement_document_attribute/7` — atomic numeric decrement.
- Full Transactions API: `create_transaction/1`, `get_transaction/1`,
  `list_transactions/1`, `update_transaction/3`, `delete_transaction/1`,
  `create_operations/2`.
- All five document CRUD functions now accept optional `transaction_id`.
- `Database.list_documents/6` — new `total` and `ttl` parameters.
- `Storage.update_file/4` — rename and re-permission files (`PUT` endpoint).
- `Storage.get_file_download/3`, `get_file_view/3`, `get_file_preview/3` —
  new `token` parameter for unauthenticated access via the Tokens API.
- `Storage.list_files/4` — new `total` parameter.
- `Teams.list/3` and `Teams.list_memberships/4` — new `total` parameter.
- `Teams.update_name/2` — preferred alias for `Teams.update/2`.
- `Functions.list_executions/4` — new `total` parameter.
- `Avatars.get_screenshot/2` — headless-browser screenshot endpoint (18 opts).
- `config/runtime.exs` — new file with production-safe `System.fetch_env!` config.
- `.credo.exs` — strict Credo configuration.
- `.github/workflows/ci.yml` — GitHub Actions CI pipeline (test + dialyzer).
- Comprehensive unit test suite covering all utilities and constant modules.

### Fixed

- **`Accounts`** — `create_verification` / `update_verification` paths corrected
  from `/account/verification` to `/account/verifications/email`.
- **`Accounts`** — phone verification paths corrected to `/account/verifications/phone`.
- **`Accounts`** — MFA challenge paths corrected from `/mfa/challenge` to
  `/mfa/challenges` (plural). All previous MFA flows silently returned 404.
- **`Accounts`** — `update_mfa_challenge/2` return type corrected to `Session.t()`.
- **`Client`** — variable rebinding of `options` in `prepare_request/4` resolved.
- **`Client`** — `call/5` spec tightened from `any()` to `map() | nil | binary()`.
- **`Storage`** — `create_file` previously passed raw binary as `payload["file"]`,
  which `Client.process_payload` would coerce to a string via `"#{value}"`,
  silently corrupting every upload. Now correctly builds the base64 map.
- **`GraphQL`** — single-function pipe `|> handle_response()` replaced with
  direct `{:ok, Client.call(...)}` wrapping (Credo `SingleFunctionToBlockPipe`).
- **`Health` / `Messaging`** — same single-function pipe pattern fixed.
- **`AppwriteException`** — `@impl true` corrected to `@impl Exception`.
- **`Application`** — `@impl true` corrected to `@impl Application`.
- **`TestingService.StorageService`** — hardcoded API key and project ID removed.
- CRLF line endings stripped from all source files.

### Removed

- `{:poison, "~> 6.0"}` dependency — was never used; only Jason is needed.
- `{:uuid, "~> 1.1"}` dependency — replaced with stdlib `:crypto`.
- Dead `handle_response/1` private functions across multiple service files.

## [0.3.0] — 2026-05-19

Initial gap-fill release. See commit history for details.

## [0.2.1] — 2024-11-XX

Original release by Kanishka Naik.

[1.0.0]: https://github.com/iamkanishka/appwrite/compare/v0.3.0...v1.0.0
[0.3.0]: https://github.com/iamkanishka/appwrite/compare/v0.2.1...v0.3.0
[0.2.1]: https://github.com/iamkanishka/appwrite/releases/tag/v0.2.1
