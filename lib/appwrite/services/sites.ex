defmodule Appwrite.Services.Sites do
  @moduledoc """
  The Sites service allows you to deploy and manage static or server-rendered
  web applications hosted on Appwrite Cloud.

  This is an entirely new Appwrite Cloud service added in v1.0.0.

  ## Concepts

  - **Site** – a deployable web application (think Vercel/Netlify projects)
  - **Deployment** – a specific build/version of a Site (each push creates one)
  - **Variable** – environment variable scoped to a Site (separate from Functions)
  - **Log** – a build or runtime log entry for a Deployment
  """

  use Appwrite.Services.Base
  # Dialyzer: Client.call/5 returns map()|nil|binary(). Specs below are
  # documentation contracts; the @dialyzer attribute suppresses the resulting
  # spec_mismatch warnings.

  # ────────────────────────────────────────────────
  # Sites
  # ────────────────────────────────────────────────

  @doc """
  Create a new Site.

  ## Parameters
  - `site_id` (required) – unique identifier; use `"unique()"` to auto-generate
  - `name` (required) – display name
  - `framework` (optional) – framework hint: `"nextjs"`, `"nuxt"`, `"sveltekit"`,
    `"astro"`, `"remix"`, `"other"`, etc.
  - `opts` keyword list:
    - `:build_command` – shell command to build the site
    - `:output_directory` – directory of the build output (e.g. `"dist"`)
    - `:install_command` – shell command to install dependencies
    - `:root_directory` – monorepo sub-path
    - `:specification` – compute specification for SSR (e.g. `"s-1vcpu-512mb"`)
    - `:timeout` – max execution time for SSR in seconds
    - `:enabled` – boolean (default `true`)
    - `:logging` – boolean — enable/disable access logs (default `true`)
  """
  @spec create_site(String.t(), String.t(), String.t() | nil, keyword()) ::
          {:ok, map()} | {:error, any()}
  def create_site(site_id, name, framework \\ nil, opts \\ []) do
    with :ok <- require_all(site_id: site_id, name: name) do
      payload =
        %{"siteId" => site_id, "name" => name}
        |> maybe_put("framework", framework)
        |> maybe_put("buildCommand", opts[:build_command])
        |> maybe_put("outputDirectory", opts[:output_directory])
        |> maybe_put("installCommand", opts[:install_command])
        |> maybe_put("rootDirectory", opts[:root_directory])
        |> maybe_put("specification", opts[:specification])
        |> maybe_put("timeout", opts[:timeout])
        |> maybe_put("enabled", opts[:enabled])
        |> maybe_put("logging", opts[:logging])

      json_call("post", "/v1/sites", payload)
    end
  end

  @doc """
  List all Sites in the project.

  ## Parameters
  - `queries` (optional)
  - `search` (optional)
  """
  @spec list_sites([String.t()] | nil, String.t() | nil) :: {:ok, map()} | {:error, any()}
  def list_sites(queries \\ nil, search \\ nil) do
    payload =
      %{}
      |> maybe_put("queries", queries)
      |> maybe_put("search", search)

    json_call("get", "/v1/sites", payload)
  end

  @doc """
  Get a Site by its unique ID.

  ## Parameters
  - `site_id` (required)
  """
  @spec get_site(String.t()) :: {:ok, map()} | {:error, any()}
  def get_site(site_id) do
    with :ok <- require_all(site_id: site_id) do
      json_call("get", "/v1/sites/#{site_id}", %{})
    end
  end

  @doc """
  Update a Site's configuration.

  ## Parameters
  - `site_id` (required)
  - `name` (required) – new display name
  - `opts` – same keyword list as `create_site/4` minus `site_id`
  """
  @spec update_site(String.t(), String.t(), keyword()) :: {:ok, map()} | {:error, any()}
  def update_site(site_id, name, opts \\ []) do
    with :ok <- require_all(site_id: site_id, name: name) do
      payload =
        %{"name" => name}
        |> maybe_put("framework", opts[:framework])
        |> maybe_put("buildCommand", opts[:build_command])
        |> maybe_put("outputDirectory", opts[:output_directory])
        |> maybe_put("installCommand", opts[:install_command])
        |> maybe_put("rootDirectory", opts[:root_directory])
        |> maybe_put("specification", opts[:specification])
        |> maybe_put("timeout", opts[:timeout])
        |> maybe_put("enabled", opts[:enabled])
        |> maybe_put("logging", opts[:logging])

      json_call("put", "/v1/sites/#{site_id}", payload)
    end
  end

  @doc """
  Delete a Site by its unique ID.

  ## Parameters
  - `site_id` (required)
  """
  @spec delete_site(String.t()) :: {:ok, map()} | {:error, any()}
  def delete_site(site_id) do
    with :ok <- require_all(site_id: site_id) do
      json_call("delete", "/v1/sites/#{site_id}", %{})
    end
  end

  # ────────────────────────────────────────────────
  # Deployments
  # ────────────────────────────────────────────────

  @doc """
  Create a new Deployment for a Site (upload source code as a tarball).

  ## Parameters
  - `site_id` (required)
  - `code` (required) – gzip-compressed tar archive of the site source
  - `activate` (required) – when `true`, automatically activates the deployment
  - `entry_point` (optional) – path to the server entry file (SSR only)
  """
  @spec create_deployment(String.t(), binary(), boolean(), String.t() | nil) ::
          {:ok, map()} | {:error, any()}
  def create_deployment(site_id, code, activate, entry_point \\ nil) do
    with :ok <- require_all(site_id: site_id, code: code, activate: activate) do
      payload =
        %{"code" => code, "activate" => activate}
        |> maybe_put("entrypoint", entry_point)

      try do
        {:ok,
         Client.call(
           "post",
           "/v1/sites/#{site_id}/deployments",
           %{"content-type" => "multipart/form-data"},
           payload
         )}
      rescue
        e -> {:error, e}
      end
    end
  end

  @doc """
  List Deployments for a Site.

  ## Parameters
  - `site_id` (required)
  - `queries` (optional)
  - `search` (optional)
  """
  @spec list_deployments(String.t(), [String.t()] | nil, String.t() | nil) ::
          {:ok, map()} | {:error, any()}
  def list_deployments(site_id, queries \\ nil, search \\ nil) do
    with :ok <- require_all(site_id: site_id) do
      payload =
        %{}
        |> maybe_put("queries", queries)
        |> maybe_put("search", search)

      json_call("get", "/v1/sites/#{site_id}/deployments", payload)
    end
  end

  @doc """
  Get a Deployment by its unique ID.

  ## Parameters
  - `site_id` (required)
  - `deployment_id` (required)
  """
  @spec get_deployment(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def get_deployment(site_id, deployment_id) do
    with :ok <- require_all(site_id: site_id, deployment_id: deployment_id) do
      json_call("get", "/v1/sites/#{site_id}/deployments/#{deployment_id}", %{})
    end
  end

  @doc """
  Update a Deployment — activate it (make it live).

  ## Parameters
  - `site_id` (required)
  - `deployment_id` (required)
  """
  @spec update_deployment_status(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def update_deployment_status(site_id, deployment_id) do
    with :ok <- require_all(site_id: site_id, deployment_id: deployment_id) do
      json_call("patch", "/v1/sites/#{site_id}/deployments/#{deployment_id}", %{})
    end
  end

  @doc """
  Delete a Deployment by its unique ID.

  ## Parameters
  - `site_id` (required)
  - `deployment_id` (required)
  """
  @spec delete_deployment(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def delete_deployment(site_id, deployment_id) do
    with :ok <- require_all(site_id: site_id, deployment_id: deployment_id) do
      json_call("delete", "/v1/sites/#{site_id}/deployments/#{deployment_id}", %{})
    end
  end

  @doc """
  Download a Deployment's source archive.

  ## Parameters
  - `site_id` (required)
  - `deployment_id` (required)

  Returns the download URL as a string.
  """
  @spec get_deployment_download(String.t(), String.t()) :: {:ok, String.t()} | {:error, any()}
  def get_deployment_download(site_id, deployment_id) do
    with :ok <- require_all(site_id: site_id, deployment_id: deployment_id) do
      base = Client.default_config()["endpoint"]
      project = Client.default_config()["project"]
      url = "#{base}/v1/sites/#{site_id}/deployments/#{deployment_id}/download?project=#{project}"
      {:ok, url}
    end
  end

  # ────────────────────────────────────────────────
  # Variables
  # ────────────────────────────────────────────────

  @doc """
  Create an environment Variable for a Site.

  ## Parameters
  - `site_id` (required)
  - `key` (required) – variable name (e.g. `"API_KEY"`)
  - `value` (required) – variable value
  """
  @spec create_variable(String.t(), String.t(), String.t()) ::
          {:ok, map()} | {:error, any()}
  def create_variable(site_id, key, value) do
    with :ok <- require_all(site_id: site_id, key: key, value: value) do
      json_call("post", "/v1/sites/#{site_id}/variables", %{"key" => key, "value" => value})
    end
  end

  @doc """
  List Variables for a Site.

  ## Parameters
  - `site_id` (required)
  """
  @spec list_variables(String.t()) :: {:ok, map()} | {:error, any()}
  def list_variables(site_id) do
    with :ok <- require_all(site_id: site_id) do
      json_call("get", "/v1/sites/#{site_id}/variables", %{})
    end
  end

  @doc """
  Get a Variable by its unique ID.

  ## Parameters
  - `site_id` (required)
  - `variable_id` (required)
  """
  @spec get_variable(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def get_variable(site_id, variable_id) do
    with :ok <- require_all(site_id: site_id, variable_id: variable_id) do
      json_call("get", "/v1/sites/#{site_id}/variables/#{variable_id}", %{})
    end
  end

  @doc """
  Update a Variable.

  ## Parameters
  - `site_id` (required)
  - `variable_id` (required)
  - `key` (required)
  - `value` (optional)
  """
  @spec update_variable(String.t(), String.t(), String.t(), String.t() | nil) ::
          {:ok, map()} | {:error, any()}
  def update_variable(site_id, variable_id, key, value \\ nil) do
    with :ok <- require_all(site_id: site_id, variable_id: variable_id, key: key) do
      payload = %{"key" => key} |> maybe_put("value", value)
      json_call("put", "/v1/sites/#{site_id}/variables/#{variable_id}", payload)
    end
  end

  @doc """
  Delete a Variable by its unique ID.

  ## Parameters
  - `site_id` (required)
  - `variable_id` (required)
  """
  @spec delete_variable(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def delete_variable(site_id, variable_id) do
    with :ok <- require_all(site_id: site_id, variable_id: variable_id) do
      json_call("delete", "/v1/sites/#{site_id}/variables/#{variable_id}", %{})
    end
  end

  # ────────────────────────────────────────────────
  # Logs
  # ────────────────────────────────────────────────

  @doc """
  List build/runtime Logs for a Site.

  ## Parameters
  - `site_id` (required)
  - `queries` (optional)
  """
  @spec list_logs(String.t(), [String.t()] | nil) :: {:ok, map()} | {:error, any()}
  def list_logs(site_id, queries \\ nil) do
    with :ok <- require_all(site_id: site_id) do
      payload = maybe_put(%{}, "queries", queries)
      json_call("get", "/v1/sites/#{site_id}/logs", payload)
    end
  end

  @doc """
  Get a specific Log entry.

  ## Parameters
  - `site_id` (required)
  - `log_id` (required)
  """
  @spec get_log(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def get_log(site_id, log_id) do
    with :ok <- require_all(site_id: site_id, log_id: log_id) do
      json_call("get", "/v1/sites/#{site_id}/logs/#{log_id}", %{})
    end
  end

  @doc """
  Delete a specific Log entry.

  ## Parameters
  - `site_id` (required)
  - `log_id` (required)
  """
  @spec delete_log(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def delete_log(site_id, log_id) do
    with :ok <- require_all(site_id: site_id, log_id: log_id) do
      json_call("delete", "/v1/sites/#{site_id}/logs/#{log_id}", %{})
    end
  end

  # ────────────────────────────────────────────────
  # Private helpers
  # ────────────────────────────────────────────────
end
