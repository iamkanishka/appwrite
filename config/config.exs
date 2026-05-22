import Config

# Default SDK configuration.
# Override per-environment in config/dev.exs, config/test.exs, config/prod.exs.
# In production applications, use config/runtime.exs with System.fetch_env!/1.
config :appwrite,
  project_id: System.get_env("APPWRITE_PROJECT_ID"),
  secret: System.get_env("APPWRITE_SECRET"),
  root_uri: System.get_env("APPWRITE_ENDPOINT", "https://cloud.appwrite.io/v1")

import_config "#{config_env()}.exs"
