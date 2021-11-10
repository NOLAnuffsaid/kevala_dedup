defmodule KevalaDedupTest do
  use ExUnit.Case, async: true

  import Mox

  setup :verify_on_exit!

  describe "KevalaDedup.dedup/2" do
    test "empty file path returns error tuple" do
      assert {:error, :emptyfilepath} = KevalaDedup.dedup("", "email")
    end

    test "unknown strategy returns error tuple" do
      assert {:error, :unknownstrat} = KevalaDedup.dedup(phone_duplicates(), "first_name")
    end

    test "valid params returns a success tuple" do
      expect(KevalaDedup.DedupStrategyMock, :dedup, fn
        _ ->
          [
            ["FirstName", "LastName", "Email", "Phone"],
            ["John", "Doe", "jdoe@unknown.com", "5555550000"]
          ]
      end)

      assert {:ok, _file_path} = KevalaDedup.dedup(phone_duplicates(), "phone")
    end
  end

  defp phone_duplicates do
    "#{File.cwd!()}/test/support/resources/phone_dup.csv"
  end
end
