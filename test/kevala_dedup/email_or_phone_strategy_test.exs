defmodule KevalaDedup.EmailOrPhoneStrategyTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias KevalaDedup.EmailOrPhoneStrategy

  import StreamData

  property "removes duplicate email addresses and phone numbers in csv data" do
    check all phones <- nonempty(list_of(string([?0..?9], length: 10), min_length: 2,  max_length: 6)),
              emails <- nonempty(list_of(string(:ascii), min_length: 2,  max_length: 9)),
              csv_data <- nonempty(list_of(fixed_list([ string(:printable), string(:printable), member_of(emails), member_of(phones) ]), length: 50)) do
      data_count = Enum.count(csv_data)
      dedup_count = Enum.count(EmailOrPhoneStrategy.dedup(csv_data))
      assert data_count != dedup_count
    end
  end
end
