defmodule AppwriteTest do
  use ExUnit.Case, async: true

  doctest Appwrite.Utils.Query
  doctest Appwrite.Utils.Permission
  doctest Appwrite.Utils.Role
  doctest Appwrite.Utils.Id
  doctest Appwrite.Utils.General

  alias Appwrite.Consts.AuthenticationFactor
  alias Appwrite.Consts.OAuthProvider
  alias Appwrite.Exceptions.AppwriteException
  alias Appwrite.Utils.Client
  alias Appwrite.Utils.General
  alias Appwrite.Utils.Id
  alias Appwrite.Utils.Permission
  alias Appwrite.Utils.Query
  alias Appwrite.Utils.Role

  # ---------------------------------------------------------------------------
  # AppwriteException
  # ---------------------------------------------------------------------------

  describe "AppwriteException" do
    test "new/4 builds a struct with all fields" do
      ex = AppwriteException.new("Not found", 404, "document_not_found", %{"hint" => "check id"})
      assert ex.message == "Not found"
      assert ex.code == 404
      assert ex.type == "document_not_found"
      assert ex.response == %{"hint" => "check id"}
    end

    test "new/0 uses safe defaults" do
      ex = AppwriteException.new()
      assert ex.code == 0
      assert ex.type == "unknown"
      assert is_binary(ex.message)
    end

    test "Exception.message/1 formats the struct" do
      ex = AppwriteException.new("Forbidden", 403, "user_unauthorized", nil)
      assert Exception.message(ex) =~ "403"
      assert Exception.message(ex) =~ "user_unauthorized"
      assert Exception.message(ex) =~ "Forbidden"
    end
  end

  # ---------------------------------------------------------------------------
  # Query builder
  # ---------------------------------------------------------------------------

  describe "Query" do
    test "equal/2 encodes a scalar" do
      q = Query.equal("status", "active")

      assert Jason.decode!(q) == %{
               "method" => "equal",
               "attribute" => "status",
               "values" => ["active"]
             }
    end

    test "equal/2 accepts a list" do
      q = Query.equal("role", ["admin", "owner"])
      assert Jason.decode!(q)["values"] == ["admin", "owner"]
    end

    test "not_equal/2" do
      q = Query.not_equal("status", "deleted")
      assert Jason.decode!(q)["method"] == "notEqual"
    end

    test "less_than/2" do
      q = Query.less_than("age", 18)
      decoded = Jason.decode!(q)
      assert decoded["method"] == "lessThan"
      assert decoded["values"] == [18]
    end

    test "less_than_equal/2" do
      q = Query.less_than_equal("score", 100)
      assert Jason.decode!(q)["method"] == "lessThanEqual"
    end

    test "greater_than/2" do
      q = Query.greater_than("price", 0)
      assert Jason.decode!(q)["method"] == "greaterThan"
    end

    test "greater_than_equal/2" do
      q = Query.greater_than_equal("rating", 4)
      assert Jason.decode!(q)["method"] == "greaterThanEqual"
    end

    test "between/3" do
      q = Query.between("age", 18, 65)
      decoded = Jason.decode!(q)
      assert decoded["method"] == "between"
      assert decoded["values"] == [18, 65]
    end

    test "null?/1" do
      q = Query.null?("deletedAt")
      decoded = Jason.decode!(q)
      assert decoded["method"] == "isNull"
      assert decoded["attribute"] == "deletedAt"
      refute Map.has_key?(decoded, "values")
    end

    test "not_null?/1" do
      q = Query.not_null?("email")
      assert Jason.decode!(q)["method"] == "isNotNull"
    end

    test "search/2" do
      q = Query.search("title", "elixir")
      decoded = Jason.decode!(q)
      assert decoded["method"] == "search"
      assert decoded["values"] == ["elixir"]
    end

    test "starts_with/2" do
      q = Query.starts_with("name", "Jo")
      assert Jason.decode!(q)["method"] == "startsWith"
    end

    test "ends_with/2" do
      q = Query.ends_with("email", ".com")
      assert Jason.decode!(q)["method"] == "endsWith"
    end

    test "contains/2" do
      q = Query.contains("tags", "elixir")
      decoded = Jason.decode!(q)
      assert decoded["method"] == "contains"
    end

    test "order_asc/1" do
      q = Query.order_asc("created_at")
      decoded = Jason.decode!(q)
      assert decoded["method"] == "orderAsc"
      assert decoded["attribute"] == "created_at"
    end

    test "order_desc/1" do
      q = Query.order_desc("created_at")
      assert Jason.decode!(q)["method"] == "orderDesc"
    end

    test "limit/1" do
      q = Query.limit(25)
      decoded = Jason.decode!(q)
      assert decoded["method"] == "limit"
      assert decoded["values"] == [25]
      refute Map.has_key?(decoded, "attribute")
    end

    test "offset/1" do
      q = Query.offset(50)
      assert Jason.decode!(q)["values"] == [50]
    end

    test "cursor_after/1" do
      q = Query.cursor_after("abc123")
      assert Jason.decode!(q)["method"] == "cursorAfter"
    end

    test "cursor_before/1" do
      q = Query.cursor_before("abc123")
      assert Jason.decode!(q)["method"] == "cursorBefore"
    end

    test "select/1" do
      q = Query.select(["id", "name", "email"])
      decoded = Jason.decode!(q)
      assert decoded["method"] == "select"
      assert decoded["values"] == ["id", "name", "email"]
    end

    test "logical_or/1 nests decoded queries" do
      q = Query.logical_or([Query.equal("a", 1), Query.equal("b", 2)])
      decoded = Jason.decode!(q)
      assert decoded["method"] == "or"
      assert length(decoded["values"]) == 2
    end

    test "logical_and/1 nests decoded queries" do
      q = Query.logical_and([Query.equal("active", true), Query.greater_than("age", 18)])
      decoded = Jason.decode!(q)
      assert decoded["method"] == "and"
      assert length(decoded["values"]) == 2
    end
  end

  # ---------------------------------------------------------------------------
  # Permission builder
  # ---------------------------------------------------------------------------

  describe "Permission" do
    test "read/1" do
      assert Permission.read("any") == ~s|read("any")|
    end

    test "write/1" do
      assert Permission.write("users") == ~s|write("users")|
    end

    test "create/1" do
      assert Permission.create("team:abc") == ~s|create("team:abc")|
    end

    test "update/1" do
      assert Permission.update("user:123") == ~s|update("user:123")|
    end

    test "delete/1" do
      assert Permission.delete("label:admin") == ~s|delete("label:admin")|
    end
  end

  # ---------------------------------------------------------------------------
  # Role builder
  # ---------------------------------------------------------------------------

  describe "Role" do
    test "any/0" do
      assert Role.any() == "any"
    end

    test "user/1" do
      assert Role.user("abc") == "user:abc"
    end

    test "user/2 with status" do
      assert Role.user("abc", "verified") == "user:abc/verified"
    end

    test "users/0" do
      assert Role.users() == "users"
    end

    test "users/1 with status" do
      assert Role.users("verified") == "users/verified"
    end

    test "guests/0" do
      assert Role.guests() == "guests"
    end

    test "team/1" do
      assert Role.team("t1") == "team:t1"
    end

    test "team/2 with role" do
      assert Role.team("t1", "admin") == "team:t1/admin"
    end

    test "member/1" do
      assert Role.member("m1") == "member:m1"
    end

    test "label/1" do
      assert Role.label("vip") == "label:vip"
    end
  end

  # ---------------------------------------------------------------------------
  # Id generator
  # ---------------------------------------------------------------------------

  describe "Id" do
    test "custom/1 returns the value unchanged" do
      assert Id.custom("my-id") == "my-id"
    end

    test "unique/0 returns a non-empty string" do
      id = Id.unique()
      assert is_binary(id)
      assert byte_size(id) > 0
    end

    test "unique/1 with larger padding is longer" do
      assert String.length(Id.unique(15)) > String.length(Id.unique(1))
    end

    test "unique/0 generates different IDs on successive calls" do
      ids = Enum.map(1..50, fn _ -> Id.unique() end)
      assert Enum.uniq(ids) == ids
    end
  end

  # ---------------------------------------------------------------------------
  # General utilities
  # ---------------------------------------------------------------------------

  describe "General" do
    test "generate_unique_id/0 returns a valid UUID v4" do
      uuid = General.generate_unique_id()

      assert String.match?(
               uuid,
               ~r/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/
             )
    end

    test "generate_unique_id/0 generates different values" do
      ids = Enum.map(1..20, fn _ -> General.generate_unique_id() end)
      assert Enum.uniq(ids) == ids
    end

    test "bytes_to_human_readable/1 — bytes" do
      assert General.bytes_to_human_readable(500) == "500 Bytes"
    end

    test "bytes_to_human_readable/1 — KB" do
      result = General.bytes_to_human_readable(2048)
      assert result =~ "KB"
    end

    test "bytes_to_human_readable/1 — MB" do
      result = General.bytes_to_human_readable(1_500_000)
      assert result =~ "MB"
    end

    test "bytes_to_human_readable/1 — GB" do
      result = General.bytes_to_human_readable(2_000_000_000)
      assert result =~ "GB"
    end
  end

  # ---------------------------------------------------------------------------
  # Consts
  # ---------------------------------------------------------------------------

  describe "Appwrite.Consts.OAuthProvider" do
    test "valid?/1 returns true for known providers" do
      assert OAuthProvider.valid?("google")
      assert OAuthProvider.valid?("github")
      assert OAuthProvider.valid?("apple")
    end

    test "valid?/1 returns false for unknown providers" do
      refute OAuthProvider.valid?("myspace")
      refute OAuthProvider.valid?("")
    end

    test "validate/1 returns ok tuple for valid" do
      assert {:ok, "google"} = OAuthProvider.validate("google")
    end

    test "validate/1 returns error tuple for invalid" do
      assert {:error, _msg} = OAuthProvider.validate("unknown")
    end

    test "validate!/1 raises for invalid" do
      assert_raise ArgumentError, fn -> OAuthProvider.validate!("bad") end
    end

    test "values/0 returns a non-empty list of strings" do
      values = OAuthProvider.values()
      assert is_list(values)
      assert values != []
      assert Enum.all?(values, &is_binary/1)
    end
  end

  describe "Appwrite.Consts.AuthenticationFactor" do
    test "valid?/1 for known factors" do
      assert AuthenticationFactor.valid?("totp") or
               Enum.any?(AuthenticationFactor.values(), fn v ->
                 AuthenticationFactor.valid?(v)
               end)
    end
  end

  # ---------------------------------------------------------------------------
  # Client.flatten/2
  # ---------------------------------------------------------------------------

  describe "Appwrite.Utils.Client.flatten/2" do
    test "flat map is unchanged in structure" do
      assert Client.flatten(%{"key" => "value"}) == %{"key" => "value"}
    end

    test "nested map uses bracket notation" do
      result = Client.flatten(%{"a" => %{"b" => "v"}})
      assert result == %{"a[b]" => "v"}
    end

    test "list uses indexed bracket notation" do
      result = Client.flatten(%{"items" => ["x", "y"]})
      assert result == %{"items[0]" => "x", "items[1]" => "y"}
    end

    test "deeply nested structure" do
      result = Client.flatten(%{"a" => %{"b" => %{"c" => 42}}})
      assert result == %{"a[b][c]" => 42}
    end
  end

  # ---------------------------------------------------------------------------
  # Error / exception modules
  # ---------------------------------------------------------------------------

  describe "Missing*Error exceptions" do
    test "MissingProjectIdError is a valid exception" do
      ex = %Appwrite.MissingProjectIdError{}
      assert is_binary(Exception.message(ex))
      assert Exception.message(ex) =~ "project_id"
    end

    test "MissingSecretError is a valid exception" do
      ex = %Appwrite.MissingSecretError{}
      assert Exception.message(ex) =~ "secret"
    end

    test "MissingRootUriError is a valid exception" do
      ex = %Appwrite.MissingRootUriError{}
      assert Exception.message(ex) =~ "root_uri"
    end
  end
end
