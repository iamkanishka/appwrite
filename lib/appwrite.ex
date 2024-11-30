defmodule Appwrite do
  alias Appwrite.Utils.Client

  defmodule MissingProjectIdError do
    defexception message: """
                 The `project_id` is required for calls to Appwrite. Please either configure `appwrite_project_id`
                 in your config.exs file.

                 config #{Client.get_app_name()}, appwrite_project_id: "your_project_id" (test)
                 config #{Client.get_app_name()}, appwrite_project_id: "your_project_id" (development)
                 config #{Client.get_app_name()}, appwrite_project_id: "your_project_id" (production)
                 """
  end

  defmodule MissingSecretError do
    defexception message: """
                 The `secret` is required for calls to Appwrite. Please either configure `appwrite_secret`
                 in your config.exs file.

                 config #{Client.get_app_name()}, appwrite_secret: "your_secret" (test)
                 config #{Client.get_app_name()}, appwrite_secret: "your_secret" (development)
                 config #{Client.get_app_name()}, appwrite_secret: "your_secret" (production)
                 """
  end

  defmodule MissingRootUriError do
    defexception message: """
                 The root_uri is required to specify the Appwrite environment to which you are
                 making calls, i.e. sandbox, development or production. Please configure appwrite_root_uri in
                 your config.exs file.

                 config #{Client.get_app_name()}, appwrite_secret:  "https://cloud.appwrite.io/v1" (test)
                 config #{Client.get_app_name()}, appwrite_secret:  "https://cloud.appwrite.io/v1" (development)
                 config #{Client.get_app_name()}, appwrite_secret:  "https://cloud.appwrite.io/v1" (production)
                 """
  end
end
