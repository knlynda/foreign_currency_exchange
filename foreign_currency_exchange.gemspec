require File.expand_path('../lib/foreign_currency_exchange/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'foreign_currency_exchange'
  gem.version     = ForeignCurrencyExchange::VERSION
  gem.date        = '2017-04-24'
  gem.summary     = 'Foreign currency exchange'
  gem.description = 'Ruby gem to perform currency conversion and arithmetic with different currencies'
  gem.authors     = ['Konstantin Lynda']
  gem.email       = 'knlynda@gmail.com'
  gem.files       = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.require_paths = ['lib']
  gem.homepage    = 'http://rubygems.org/gems/foreign_currency_exchange'
  gem.license     = 'MIT'
end
