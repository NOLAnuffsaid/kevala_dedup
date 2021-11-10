defmodule KevalaDedup.PhoneStrategyTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias KevalaDedup.PhoneStrategy

  import StreamData

  property "removes duplicate phone numbers in csv data" do
    check all phones <- nonempty(list_of(string([?0..?9], length: 10), min_length: 2,  max_length: 6)),
              csv_data <- nonempty(list_of(fixed_list([ string(:printable), string(:printable), string(:ascii), member_of(phones) ]), length: 25)) do
      data_count = Enum.count(csv_data)
      dedup_count = Enum.count(PhoneStrategy.dedup(csv_data))
      assert data_count != dedup_count
    end
  end
end
