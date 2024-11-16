defmodule Appwrite.Types.Execution do
  @moduledoc """
  Represents a function execution, including details like status, logs, and duration.

  ## Fields

    - `$id` (`String.t`): Execution ID.
    - `$created_at` (`String.t`): Creation date in ISO 8601 format.
    - `$updated_at` (`String.t`): Update date in ISO 8601 format.
    - `$permissions` (`[String.t]`): Execution roles.
    - `function_id` (`String.t`): Function ID.
    - `trigger` (`String.t`): Execution trigger (`http`, `schedule`, or `event`).
    - `status` (`String.t`): Execution status (`waiting`, `processing`, `completed`, or `failed`).
    - `request_method` (`String.t`): HTTP request method type.
    - `request_path` (`String.t`): HTTP request path and query.
    - `request_headers` (`[Appwrite.Types.Headers.t]`): HTTP request headers.
    - `response_status_code` (`integer`): HTTP response status code.
    - `response_body` (`String.t`): HTTP response body.
    - `response_headers` (`[Appwrite.Types.Headers.t]`): HTTP response headers.
    - `logs` (`String.t`): Function logs (last 4,000 characters).
    - `errors` (`String.t`): Function errors (last 4,000 characters).
    - `duration` (`float`): Execution duration in seconds.
    - `scheduled_at` (`String.t | nil`): Scheduled time for execution (ISO 8601 format).
  """

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
          request_headers: [Appwrite.Types.Headers.t()],
          response_status_code: integer(),
          response_body: String.t(),
          response_headers: [Appwrite.Types.Headers.t()],
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
