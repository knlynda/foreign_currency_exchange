module ForeignCurrencyExchange
  class Money
    # This module contains configuration methods for Money class
    module Configuration
      BASE_CURRENCY_RATE = 1.0

      attr_reader :base_currency, :rates

      def conversion_rates(base_currency, rates)
        @rates = rates
        @base_currency = base_currency
        check_configuration
      rescue => exception
        nullify_configuration
        raise exception
      end

      def check_configuration
        check_rates
        check_base_currency_rate
      end

      private

      def nullify_configuration
        @rates = nil
        @base_currency = nil
      end

      def check_rates
        raise InvalidRatesError unless valid_rates?
      end

      def check_base_currency_rate
        raise InvalidBaseCurrencyRateError unless valid_base_currency_rate?
      end

      def valid_rates?
        rates.is_a?(Hash) && !rates.empty? &&
          rates.values.all? { |v| v.is_a?(Numeric) && v.positive? }
      end

      def valid_base_currency_rate?
        !rates.key?(base_currency) ||
          rates[base_currency] == BASE_CURRENCY_RATE
      end
    end
  end
end
