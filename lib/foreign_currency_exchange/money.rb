require 'foreign_currency_exchange/money/exceptions'
require 'foreign_currency_exchange/money/configuration'

module ForeignCurrencyExchange
  # This class represents a money object.
  class Money
    AMOUNT_FORMAT = '%.2f'.freeze
    ROUND_LEVEL = 2

    extend Configuration
    extend Forwardable
    include Comparable

    attr_reader :amount, :currency
    def_delegators :'self.class', :base_currency, :rates, :new, :check_configuration

    def initialize(amount, currency)
      check_configuration # Configuration should be valid.
      check_currency(currency) # Currency should be configured before.
      @amount = prepare_amount(amount)
      @currency = currency
    end

    # Returns current object amount if currency equals to base_currency
    #   or converted current object amount to base_currency otherwise.
    def base_amount
      return amount if currency == base_currency
      prepare_amount(amount / rates[currency].to_f)
    end

    def <=>(other)
      base_amount <=> other.base_amount
    end

    def +(other)
      new_amount = amount + other.convert_to(currency).amount
      new(new_amount, currency)
    end

    def -(other)
      new_amount = amount - other.convert_to(currency).amount
      new(new_amount, currency)
    end

    # Returns new money object with multiplied current object amount,
    #   parameter multiplier should be kind of Numeric object.
    def *(multiplier)
      new(amount * multiplier, currency)
    end

    # Returns new money object with divided current object amount,
    #   parameter divider should be kind of Numeric object.
    def /(divider)
      raise ZeroDivisionError if divider.zero?
      new(amount / divider.to_f, currency)
    end

    def to_s
      "#{formatted_amount} #{currency}"
    end

    def inspect
      to_s
    end

    # Returns new money object converted to given currency,
    #   raises UnknownCurrencyError in case when given currency is unknown.
    def convert_to(other_currency)
      new_amount = calculate_amount(other_currency)
      new(new_amount, other_currency)
    end

    private

    def prepare_amount(amount)
      amount.integer? ? amount : amount.round(ROUND_LEVEL)
    end

    def formatted_amount
      amount.integer? ? amount.to_s : format(AMOUNT_FORMAT, amount)
    end

    # Returns amount based on given currency,
    #   raises UnknownCurrencyError in case when given other_currency is unknown.
    def calculate_amount(other_currency)
      check_currency(other_currency)
      return amount if other_currency == currency
      return base_amount if other_currency == base_currency
      base_amount * rates[other_currency]
    end

    # Checks that currency is known otherwise raises UnknownCurrencyError.
    def check_currency(currency)
      return if base_currency == currency || rates.keys.include?(currency)
      raise UnknownCurrencyError
    end
  end
end
