defmodule Appwrite.Types.Execution do
  @moduledoc """
  A record of a single Appwrite Function execution.

  System fields are mapped from `$`-prefixed API keys to plain snake_case
  struct keys.

  HTTP request/response headers are each a list of maps with `"name"` and
  `"value"` string keys, matching the Appwrite REST response shape:

      [%{"name" => "content-type", "value" => "application/json"}]

  A dedicated `Header` struct may be introduced later; for now `[map()]`
  avoids a phantom-type reference.

  ## Fields

  - `id` (`String.t()`) — execution ID (`$id`).
  - `created_at` (`String.t()`) — creation timestamp ISO 8601 (`$createdAt`).
  - `updated_at` (`String.t()`) — last-updated timestamp ISO 8601 (`$updatedAt`).
  - `permissions` (`[String.t()]`) — Appwrite permission strings (`$permissions`).
  - `function_id` (`String.t()`) — parent function ID.
  - `trigger` (`String.t()`) — what triggered execution: `"http"`, `"schedule"`, or `"event"`.
  - `status` (`String.t()`) — `"waiting"`, `"processing"`, `"completed"`, or `"failed"`.
  - `request_method` (`String.t()`) — HTTP method of the triggering request.
  - `request_path` (`String.t()`) — path and query string of the triggering request.
  - `request_headers` (`[map()]`) — headers of the triggering request.
  - `response_status_code` (`non_neg_integer()`) — HTTP status code returned by the function.
  - `response_body` (`String.t()`) — response body (may be truncated).
  - `response_headers` (`[map()]`) — headers returned by the function.
  - `logs` (`String.t()`) — last 4 000 characters of function stdout.
  - `errors` (`String.t()`) — last 4 000 characters of function stderr.
  - `duration` (`float()`) — wall-clock execution time in seconds.
  - `scheduled_at` (`String.t() | nil`) — ISO 8601 scheduled start time, or `nil`.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          id: String.t(),
          created_at: String.t(),
          updated_at: String.t(),
          permissions: [String.t()],
          function_id: String.t(),
          trigger: String.t(),
          status: String.t(),
          request_method: String.t(),
          request_path: String.t(),
          request_headers: [map()],
          response_status_code: non_neg_integer(),
          response_body: String.t(),
          response_headers: [map()],
          logs: String.t(),
          errors: String.t(),
          duration: float(),
          scheduled_at: String.t() | nil
        }

  defstruct [
    :id,
    :created_at,
    :updated_at,
    :permissions,
    :function_id,
    :trigger,
    :status,
    :request_method,
    :request_path,
    :request_headers,
    :response_status_code,
    :response_body,
    :response_headers,
    :logs,
    :errors,
    :duration,
    :scheduled_at
  ]
end
