import Config

# Development: override with local values or .env file.
# Never commit real credentials to source control.
config :appwrite,
  project_id: System.get_env("APPWRITE_PROJECT_ID", "your-dev-project-id"),
  secret: System.get_env("APPWRITE_SECRET", "your-dev-secret"),
  root_uri: System.get_env("APPWRITE_ENDPOINT", "https://cloud.appwrite.io/v1")
