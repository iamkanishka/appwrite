import Config

# Production: values should come from environment variables at runtime.
# Consider using config/runtime.exs (evaluated at boot) instead of this file
# (evaluated at compile time) for true runtime configuration.
config :appwrite,
  project_id: System.get_env("APPWRITE_PROJECT_ID"),
  secret: System.get_env("APPWRITE_SECRET"),
  root_uri: System.get_env("APPWRITE_ENDPOINT", "https://cloud.appwrite.io/v1")
