defmodule KevalaDedup.EmailStrategyTest do
  use ExUnit.Case
  use ExUnitProperties

  alias KevalaDedup.EmailStrategy

  import StreamData

  property "removes duplicate email addresses in csv data" do
    check all emails <- nonempty(list_of(string(:ascii), min_length: 2,  max_length: 4)),
              csv_data <- nonempty(list_of(fixed_list([ string(:printable), string(:printable), member_of(emails), string([?0..?9]) ]), length: 25)) do
      data_count = Enum.count(csv_data)
      dedup_count = Enum.count(EmailStrategy.dedup(csv_data))
      assert data_count != dedup_count
    end
  end
end
