import Config

# Test environment: use environment variables so CI pipelines can inject them.
# Unit tests that do not make real HTTP calls do not need valid values.
config :appwrite,
  project_id: System.get_env("APPWRITE_TEST_PROJECT_ID", "test-project-id"),
  secret: System.get_env("APPWRITE_TEST_SECRET", "test-secret"),
  root_uri: System.get_env("APPWRITE_TEST_ENDPOINT", "https://cloud.appwrite.io/v1"),
  test_bucket_id: System.get_env("APPWRITE_TEST_BUCKET_ID", "test-bucket")
