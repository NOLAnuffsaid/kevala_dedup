defmodule KevalaDedup.PhoneStrategy do
  @behaviour KevalaDedup.DedupStrategy

  def dedup(data) do
    {deduped_data, _} =
      Enum.reduce(data, {[], %{}}, fn
        [_, _, _, phone] = row, {[], %{}} ->
          {[row], %{phone => true}}

        [_, _, _, phone], {_, known_phones} = result
        when is_map_key(known_phones, phone) ->
          result

        [_, _, _, phone] = row, {decoded_data, known_phones} ->
          {[row | decoded_data], Map.merge(known_phones, %{phone => true})}
      end)

    Enum.reverse(deduped_data)
  end
end
