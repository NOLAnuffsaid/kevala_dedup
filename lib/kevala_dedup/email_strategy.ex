defmodule KevalaDedup.EmailStrategy do
  alias KevalaDedup.DedupStrategy

  @behaviour DedupStrategy

  @impl DedupStrategy
  def dedup([]) do
    []
  end

  def dedup(data) do
    {deduped_data, _} =
      Enum.reduce(data, {[], %{}}, fn
        [_, _, email, _] = row, {[], %{}} ->
          {[row], %{email => true}}

        [_, _, email, _], {_, known_emails} = result
        when is_map_key(known_emails, email) ->
          result

        [_, _, email, _] = row, {decoded_data, known_emails} ->
          {[row | decoded_data], Map.merge(known_emails, %{email => true})}
      end)

    Enum.reverse(deduped_data)
  end
end
