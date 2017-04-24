module ForeignCurrencyExchange
  class Money
    UnknownCurrencyError = Class.new(StandardError)
    InvalidRatesError = Class.new(StandardError)
    InvalidBaseCurrencyRateError = Class.new(StandardError)
  end
end
