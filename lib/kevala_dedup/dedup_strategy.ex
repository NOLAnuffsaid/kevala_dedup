defmodule KevalaDedup.DedupStrategy do
    @type csv_record() :: list(String.t())
    @type csv_data() :: list(csv_record())

    @callback dedup(csv_data()) :: csv_data()

    def dedup(file, strategy) do
      impl(strategy).dedup(file)
    end

    # In production code `impl` would be implemented in a different way.
    # `impl` would call `Application.get_env/4` to fetch the configured
    # strategy from the application's config. This affects testing
    # because we can't set the mock module in the application's config
    # to mock during tests. Which lead me to conditionally set the
    # strategy if we are in a test environment. Otherwise, the normal
    # means of selecting a strategy is used.
    if Mix.env() == :test do
      defp impl(_), do: KevalaDedup.DedupStrategyMock
    else
      defp impl("email"), do: KevalaDedup.EmailStrategy
      defp impl("phone"), do: KevalaDedup.PhoneStrategy
      defp impl("email_or_phone"), do: KevalaDedup.EmailOrPhoneStrategy
    end
end
