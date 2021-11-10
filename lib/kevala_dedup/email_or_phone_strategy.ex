  defmodule KevalaDedup.EmailOrPhoneStrategy do
    @behaviour KevalaDedup.DedupStrategy

    def dedup(data) do
      {deduped_data, _} =
        Enum.reduce(data, {[], %{}}, fn
          [_, _, email, phone] = row, {[], %{}} ->
            {[row], %{email => true, phone => true}}

          [_, _, _, phone], {_, known_emails_phones} = result
          when is_map_key(known_emails_phones, phone) ->
            result

          [_, _, email, _], {_, known_emails_phones} = result
          when is_map_key(known_emails_phones, email) ->
            result

          [_, _, email, phone] = row, {decoded_data, known_emails_phones} ->
            {[row | decoded_data],
             Map.merge(known_emails_phones, %{email => true, phone => true})}
        end)

      Enum.reverse(deduped_data)
    end
  end
