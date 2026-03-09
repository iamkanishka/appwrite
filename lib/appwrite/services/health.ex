defmodule Appwrite.Services.Health do
  @moduledoc """
  The Health service is designed to allow you to both validate and monitor
  that your Appwrite instance and all of its internal components are up and responsive.

  Use the Health service to perform system health checks, verify queue sizes,
  monitor storage availability, and check database, cache, and antivirus statuses.

  **Note:** This service requires an API key with server-side privileges.
  It is not intended for use in client-side code.
  """

  alias Appwrite.Exceptions.AppwriteException
  alias Appwrite.Utils.Client
  alias Appwrite.Types.{HealthAntivirus, HealthCertificate, HealthQueue, HealthStatus, HealthTime}

  @doc """
  Check the Appwrite HTTP server is up and responsive.

  ## Returns
  - `{:ok, HealthStatus.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get() :: {:ok, HealthStatus.t()} | {:error, AppwriteException.t()}
  def get do
    Client.call("GET", "/v1/health", %{}, %{})
    |> handle_response()
  rescue
    error -> {:error, error}
  end

  @doc """
  Check the Appwrite antivirus server is up and the connection is successful.

  Requires an active antivirus server.

  ## Returns
  - `{:ok, HealthAntivirus.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_antivirus() :: {:ok, HealthAntivirus.t()} | {:error, AppwriteException.t()}
  def get_antivirus do
    Client.call("GET", "/v1/health/anti-virus", %{}, %{})
    |> handle_response()
  rescue
    error -> {:error, error}
  end

  @doc """
  Check the Appwrite in-memory cache servers are up and responsive.

  ## Returns
  - `{:ok, HealthStatus.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_cache() :: {:ok, HealthStatus.t()} | {:error, AppwriteException.t()}
  def get_cache do
    Client.call("GET", "/v1/health/cache", %{}, %{})
    |> handle_response()
  rescue
    error -> {:error, error}
  end

  @doc """
  Get the SSL certificate for a domain.

  ## Parameters
  - `domain` (`String.t() | nil`): The domain name to check, or `nil` to check the default.

  ## Returns
  - `{:ok, HealthCertificate.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_certificate(String.t() | nil) ::
          {:ok, HealthCertificate.t()} | {:error, AppwriteException.t()}
  def get_certificate(domain \\ nil) do
    params = maybe_put(%{}, "domain", domain)

    Client.call("GET", "/v1/health/certificate", %{}, params)
    |> handle_response()
  rescue
    error -> {:error, error}
  end

  @doc """
  Check the Appwrite database servers are up and responsive.

  ## Returns
  - `{:ok, HealthStatus.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_db() :: {:ok, HealthStatus.t()} | {:error, AppwriteException.t()}
  def get_db do
    Client.call("GET", "/v1/health/db", %{}, %{})
    |> handle_response()
  rescue
    error -> {:error, error}
  end

  @doc """
  Check the Appwrite pub-sub servers are up and responsive.

  ## Returns
  - `{:ok, HealthStatus.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_pub_sub() :: {:ok, HealthStatus.t()} | {:error, AppwriteException.t()}
  def get_pub_sub do
    Client.call("GET", "/v1/health/pubsub", %{}, %{})
    |> handle_response()
  rescue
    error -> {:error, error}
  end

  @doc """
  Get the number of builds waiting to be processed in the internal queue.

  ## Parameters
  - `threshold` (`non_neg_integer() | nil`): Queue size threshold. Returns a server
    error when the queue size reaches or exceeds this value. Defaults to `5000`.

  ## Returns
  - `{:ok, HealthQueue.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_queue_builds(non_neg_integer() | nil) ::
          {:ok, HealthQueue.t()} | {:error, AppwriteException.t()}
  def get_queue_builds(threshold \\ nil) do
    params = maybe_put(%{}, "threshold", threshold)

    Client.call("GET", "/v1/health/queue/builds", %{}, params)
    |> handle_response()
  rescue
    error -> {:error, error}
  end

  @doc """
  Get the number of database changes waiting to be processed in the internal queue.

  ## Parameters
  - `name` (`String.t() | nil`): The name of the specific database queue.
  - `threshold` (`non_neg_integer() | nil`): Queue size threshold. Defaults to `5000`.

  ## Returns
  - `{:ok, HealthQueue.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_queue_databases(String.t() | nil, non_neg_integer() | nil) ::
          {:ok, HealthQueue.t()} | {:error, AppwriteException.t()}
  def get_queue_databases(name \\ nil, threshold \\ nil) do
    params =
      %{}
      |> maybe_put("name", name)
      |> maybe_put("threshold", threshold)

    Client.call("GET", "/v1/health/queue/databases", %{}, params)
    |> handle_response()
  rescue
    error -> {:error, error}
  end

  @doc """
  Get the number of background destructive changes waiting to be processed in the internal queue.

  ## Parameters
  - `threshold` (`non_neg_integer() | nil`): Queue size threshold. Defaults to `5000`.

  ## Returns
  - `{:ok, HealthQueue.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_queue_deletes(non_neg_integer() | nil) ::
          {:ok, HealthQueue.t()} | {:error, AppwriteException.t()}
  def get_queue_deletes(threshold \\ nil) do
    params = maybe_put(%{}, "threshold", threshold)

    Client.call("GET", "/v1/health/queue/deletes", %{}, params)
    |> handle_response()
  rescue
    error -> {:error, error}
  end

  @doc """
  Get the number of failed jobs in a given queue.

  ## Parameters
  - `name` (`String.t()`): The name of the queue. Valid values include
    `"v1-database"`, `"v1-deletes"`, `"v1-audits"`, `"v1-mails"`,
    `"v1-functions"`, `"v1-usage"`, `"v1-usage-dump"`, `"v1-webhooks"`,
    `"v1-certificates"`, `"v1-builds"`, `"v1-messaging"`,
    `"v1-migrations"`, `"v1-statsitems"`.
  - `threshold` (`non_neg_integer() | nil`): Queue size threshold. Defaults to `5000`.

  ## Returns
  - `{:ok, HealthQueue.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_failed_jobs(String.t(), non_neg_integer() | nil) ::
          {:ok, HealthQueue.t()} | {:error, AppwriteException.t()}
  def get_failed_jobs(name, threshold \\ nil) do
    if is_nil(name) do
      {:error, %AppwriteException{message: "name is required"}}
    else
      params = maybe_put(%{}, "threshold", threshold)

      try do
        Client.call("GET", "/v1/health/queue/failed/#{name}", %{}, params)
        |> handle_response()
      rescue
        error -> {:error, error}
      end
    end
  end

  @doc """
  Get the number of function executions waiting to be processed in the internal queue.

  ## Parameters
  - `threshold` (`non_neg_integer() | nil`): Queue size threshold. Defaults to `5000`.

  ## Returns
  - `{:ok, HealthQueue.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_queue_functions(non_neg_integer() | nil) ::
          {:ok, HealthQueue.t()} | {:error, AppwriteException.t()}
  def get_queue_functions(threshold \\ nil) do
    params = maybe_put(%{}, "threshold", threshold)

    Client.call("GET", "/v1/health/queue/functions", %{}, params)
    |> handle_response()
  rescue
    error -> {:error, error}
  end

  @doc """
  Get the number of logs waiting to be processed in the internal queue.

  ## Parameters
  - `threshold` (`non_neg_integer() | nil`): Queue size threshold. Defaults to `5000`.

  ## Returns
  - `{:ok, HealthQueue.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_queue_logs(non_neg_integer() | nil) ::
          {:ok, HealthQueue.t()} | {:error, AppwriteException.t()}
  def get_queue_logs(threshold \\ nil) do
    params = maybe_put(%{}, "threshold", threshold)

    Client.call("GET", "/v1/health/queue/logs", %{}, params)
    |> handle_response()
  rescue
    error -> {:error, error}
  end

  @doc """
  Get the number of mails waiting to be processed in the internal queue.

  ## Parameters
  - `threshold` (`non_neg_integer() | nil`): Queue size threshold. Defaults to `5000`.

  ## Returns
  - `{:ok, HealthQueue.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_queue_mails(non_neg_integer() | nil) ::
          {:ok, HealthQueue.t()} | {:error, AppwriteException.t()}
  def get_queue_mails(threshold \\ nil) do
    params = maybe_put(%{}, "threshold", threshold)

    Client.call("GET", "/v1/health/queue/mails", %{}, params)
    |> handle_response()
  rescue
    error -> {:error, error}
  end

  @doc """
  Get the number of messages waiting to be processed in the internal queue.

  ## Parameters
  - `threshold` (`non_neg_integer() | nil`): Queue size threshold. Defaults to `5000`.

  ## Returns
  - `{:ok, HealthQueue.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_queue_messaging(non_neg_integer() | nil) ::
          {:ok, HealthQueue.t()} | {:error, AppwriteException.t()}
  def get_queue_messaging(threshold \\ nil) do
    params = maybe_put(%{}, "threshold", threshold)

    Client.call("GET", "/v1/health/queue/messaging", %{}, params)
    |> handle_response()
  rescue
    error -> {:error, error}
  end

  @doc """
  Get the number of migrations waiting to be processed in the internal queue.

  ## Parameters
  - `threshold` (`non_neg_integer() | nil`): Queue size threshold. Defaults to `5000`.

  ## Returns
  - `{:ok, HealthQueue.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_queue_migrations(non_neg_integer() | nil) ::
          {:ok, HealthQueue.t()} | {:error, AppwriteException.t()}
  def get_queue_migrations(threshold \\ nil) do
    params = maybe_put(%{}, "threshold", threshold)

    Client.call("GET", "/v1/health/queue/migrations", %{}, params)
    |> handle_response()
  rescue
    error -> {:error, error}
  end

  @doc """
  Get the number of SSL certificates waiting to be renewed in the internal queue.

  ## Parameters
  - `threshold` (`non_neg_integer() | nil`): Queue size threshold. Defaults to `5000`.

  ## Returns
  - `{:ok, HealthQueue.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_queue_certificates(non_neg_integer() | nil) ::
          {:ok, HealthQueue.t()} | {:error, AppwriteException.t()}
  def get_queue_certificates(threshold \\ nil) do
    params = maybe_put(%{}, "threshold", threshold)

    Client.call("GET", "/v1/health/queue/certificates", %{}, params)
    |> handle_response()
  rescue
    error -> {:error, error}
  end

  @doc """
  Get the number of webhooks waiting to be processed in the internal queue.

  ## Parameters
  - `threshold` (`non_neg_integer() | nil`): Queue size threshold. Defaults to `5000`.

  ## Returns
  - `{:ok, HealthQueue.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_queue_webhooks(non_neg_integer() | nil) ::
          {:ok, HealthQueue.t()} | {:error, AppwriteException.t()}
  def get_queue_webhooks(threshold \\ nil) do
    params = maybe_put(%{}, "threshold", threshold)

    Client.call("GET", "/v1/health/queue/webhooks", %{}, params)
    |> handle_response()
  rescue
    error -> {:error, error}
  end

  @doc """
  Check the Appwrite local storage device is up and responsive.

  ## Returns
  - `{:ok, HealthStatus.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_storage_local() :: {:ok, HealthStatus.t()} | {:error, AppwriteException.t()}
  def get_storage_local do
    Client.call("GET", "/v1/health/storage/local", %{}, %{})
    |> handle_response()
  rescue
    error -> {:error, error}
  end

  @doc """
  Check the Appwrite storage device is up and responsive.

  ## Returns
  - `{:ok, HealthStatus.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_storage() :: {:ok, HealthStatus.t()} | {:error, AppwriteException.t()}
  def get_storage do
    Client.call("GET", "/v1/health/storage", %{}, %{})
    |> handle_response()
  rescue
    error -> {:error, error}
  end

  @doc """
  Check the Appwrite server time is synced with a remote NTP server.

  Appwrite uses NTP to handle leap seconds smoothly. A large drift may indicate
  a configuration issue on the Appwrite host.

  ## Returns
  - `{:ok, HealthTime.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_time() :: {:ok, HealthTime.t()} | {:error, AppwriteException.t()}
  def get_time do
    Client.call("GET", "/v1/health/time", %{}, %{})
    |> handle_response()
  rescue
    error -> {:error, error}
  end

  @doc """
  Check the Appwrite in-memory queue messaging servers are up and responsive.

  ## Returns
  - `{:ok, HealthStatus.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_queue() :: {:ok, HealthStatus.t()} | {:error, AppwriteException.t()}
  def get_queue do
    Client.call("GET", "/v1/health/queue", %{}, %{})
    |> handle_response()
  rescue
    error -> {:error, error}
  end

  @doc """
  Get the number of audit logs waiting to be processed in the internal queue.

  ## Parameters
  - `threshold` (`non_neg_integer() | nil`): Queue size threshold. Defaults to `5000`.

  ## Returns
  - `{:ok, HealthQueue.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_queue_audits(non_neg_integer() | nil) ::
          {:ok, HealthQueue.t()} | {:error, AppwriteException.t()}
  def get_queue_audits(threshold \\ nil) do
    params = maybe_put(%{}, "threshold", threshold)

    Client.call("GET", "/v1/health/queue/audits", %{}, params)
    |> handle_response()
  rescue
    error -> {:error, error}
  end

  @doc """
  Get the number of usage stats operations waiting to be processed in the internal queue.

  ## Parameters
  - `threshold` (`non_neg_integer() | nil`): Queue size threshold. Defaults to `5000`.

  ## Returns
  - `{:ok, HealthQueue.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_queue_usage(non_neg_integer() | nil) ::
          {:ok, HealthQueue.t()} | {:error, AppwriteException.t()}
  def get_queue_usage(threshold \\ nil) do
    params = maybe_put(%{}, "threshold", threshold)

    Client.call("GET", "/v1/health/queue/usage", %{}, params)
    |> handle_response()
  rescue
    error -> {:error, error}
  end

  @doc """
  Get the number of usage dump operations waiting to be processed in the internal queue.

  ## Parameters
  - `threshold` (`non_neg_integer() | nil`): Queue size threshold. Defaults to `5000`.

  ## Returns
  - `{:ok, HealthQueue.t()}` on success.
  - `{:error, AppwriteException.t()}` on failure.
  """
  @spec get_queue_usage_dump(non_neg_integer() | nil) ::
          {:ok, HealthQueue.t()} | {:error, AppwriteException.t()}
  def get_queue_usage_dump(threshold \\ nil) do
    params = maybe_put(%{}, "threshold", threshold)

    Client.call("GET", "/v1/health/queue/usage-dump", %{}, params)
    |> handle_response()
  rescue
    error -> {:error, error}
  end

  # --- Private Helpers ---

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)

  defp handle_response(body), do: {:ok, body}
end
