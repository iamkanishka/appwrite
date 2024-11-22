defmodule Appwrite do
  defmodule MissingProjectIdError do
    defexception message: """
                 The `project_id` is required for calls to Plaid. Please either configure `project_id`
                 in your config.exs file or pass it into the function via the `config` argument.

                 config :appwrite, project_id: "your_project_id" (test)
                 config :appwrite, project_id: "your_project_id" (development)
                 config :appwrite, project_id: "your_project_id" (production)
                 """
  end

  defmodule MissingSecretError do
    defexception message: """
                 The `secret` is required for calls to Plaid. Please either configure `secret`
                 in your config.exs file or pass it into the function via the `config` argument.

                 config :appwrite, secret: "your_secret" (test)
                 config :appwrite, secret: "your_secret" (development)
                 config :appwrite, secret: "your_secret" (production)
                 """
  end

  defmodule MissingRootUriError do
    defexception message: """
                 The root_uri is required to specify the Plaid environment to which you are
                 making calls, i.e. sandbox, development or production. Please configure root_uri in
                 your config.exs file.

                 config :appwrite, root_uri:  "https://cloud.appwrite.io/v1" (test)
                 config :appwrite, root_uri:  "https://cloud.appwrite.io/v1" (development)
                 config :appwrite, root_uri:  "https://cloud.appwrite.io/v1" (production)
                 """
  end
end
