### Installation

```bash
gem install foreign_currency_exchange
```

### Usage

```ruby
require 'foreign_currency_exchange'

# Configure the currency rates with respect to a base currency (here EUR):

ForeignCurrencyExchange::Money.conversion_rates(
  'EUR',
  'USD'     => 1.11,
  'Bitcoin' => 0.0047
)

# Instantiate money objects:

fifty_eur = ForeignCurrencyExchange::Money.new(50, 'EUR')

# Get amount and currency:

fifty_eur.amount   # => 50
fifty_eur.currency # => "EUR"
fifty_eur.inspect  # => "50 EUR"

# Convert to a different currency (should return a Money
# instance, not a String):

fifty_eur.convert_to('USD') # => 55.50 USD

# Perform operations in different currencies:

twenty_dollars = ForeignCurrencyExchange::Money.new(20, 'USD')

# Arithmetics:

fifty_eur + twenty_dollars # => 68.02 EUR
fifty_eur - twenty_dollars # => 31.98 EUR
fifty_eur / 2              # => 25 EUR
twenty_dollars * 3         # => 60 USD

# Comparisons (also in different currencies):

twenty_dollars == ForeignCurrencyExchange::Money.new(20, 'USD') # => true
twenty_dollars == ForeignCurrencyExchange::Money.new(30, 'USD') # => false

fifty_eur_in_usd = fifty_eur.convert_to('USD')
fifty_eur_in_usd == fifty_eur                                   # => true

twenty_dollars > ForeignCurrencyExchange::Money.new(5, 'USD')   # => true
twenty_dollars < fifty_eur                                      # => true
```
