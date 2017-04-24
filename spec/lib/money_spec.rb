require 'spec_helper'

RSpec.describe ForeignCurrencyExchange::Money do
  before do
    described_class.conversion_rates(
      'EUR',
      'USD'     => 1.11,
      'Bitcoin' => 0.0047
    )
  end

  describe '.new' do
    subject { described_class.new(amount, currency) }

    context 'when known currency' do
      let(:currency) { 'USD' }
      let(:amount) { 50 }

      it { is_expected.to be_an_instance_of described_class }
      it { expect(subject.currency).to eql currency }
      it { expect(subject.amount).to eql amount }
    end

    context 'when currency is base currency' do
      let(:currency) { 'EUR' }
      let(:amount) { 100 }

      it { is_expected.to be_an_instance_of described_class }
      it { expect(subject.currency).to eql currency }
      it { expect(subject.amount).to eql amount }
    end

    context 'when unknown currency' do
      let(:currency) { 'UAH' }
      let(:amount) { 30 }

      it 'raises UnknownCurrencyError' do
        expect { subject }.to raise_error described_class::UnknownCurrencyError
      end
    end
  end

  describe '#base_amount' do
    subject { money_object.base_amount }
    let(:money_object) { described_class.new(10, currency) }

    context 'when object currency is base currency' do
      let(:currency) { 'EUR' }
      it { is_expected.to eql 10 }
    end

    context 'when object currency is known currency' do
      let(:currency) { 'USD' }
      it { is_expected.to eql 9.01 }
    end

    context 'when object currency is known currency' do
      let(:currency) { 'Bitcoin' }
      it { is_expected.to eql 2127.66 }
    end
  end

  describe '#<=>' do
    subject { money_object <=> other_money_object }

    context 'when same amount and currency' do
      let(:money_object) { described_class.new(5.01, 'EUR') }
      let(:other_money_object) { described_class.new(5.01, 'EUR') }

      it { is_expected.to be_zero }
    end

    context 'when amount greater then other amount (0.001)' do
      let(:money_object) { described_class.new(5.012, 'EUR') }
      let(:other_money_object) { described_class.new(5.011, 'EUR') }

      it { is_expected.to be_zero }
    end

    context 'when amount greater then other amount (0.01)' do
      let(:money_object) { described_class.new(5.02, 'EUR') }
      let(:other_money_object) { described_class.new(5.01, 'EUR') }

      it { is_expected.to eql 1 }
    end

    context 'when amount less then other amount (0.01)' do
      let(:money_object) { described_class.new(5.01, 'EUR') }
      let(:other_money_object) { described_class.new(5.02, 'EUR') }

      it { is_expected.to eql(-1) }
    end
  end

  describe '#+' do
    subject { money_object + other_money_object }

    let(:money_object) { described_class.new(5, 'EUR') }
    let(:other_money_object) { described_class.new(10, 'EUR') }

    it { expect(subject.amount).to eql 15 }
    it { expect(subject.currency).to eql 'EUR' }

    context 'when different currencies' do
      let(:money_object) { described_class.new(5, 'USD') }
      let(:other_money_object) { described_class.new(10, 'EUR') }

      it { expect(subject.amount).to eql 16.1 }
      it { expect(subject.currency).to eql 'USD' }
    end
  end

  describe '#-' do
    subject { money_object - other_money_object }

    let(:money_object) { described_class.new(10, 'EUR') }
    let(:other_money_object) { described_class.new(5, 'EUR') }

    it { expect(subject.amount).to eql 5 }
    it { expect(subject.currency).to eql 'EUR' }

    context 'when different currencies' do
      let(:money_object) { described_class.new(10, 'USD') }
      let(:other_money_object) { described_class.new(5, 'EUR') }

      it { expect(subject.amount).to eql 4.45 }
      it { expect(subject.currency).to eql 'USD' }
    end
  end

  describe '#*' do
    subject { described_class.new(10, 'EUR') * 10.00001 }

    it { expect(subject.amount).to eql 100.0 }
    it { expect(subject.currency).to eql 'EUR' }
  end

  describe '#/' do
    subject { described_class.new(10, 'EUR') / 10.00001 }

    it { expect(subject.amount).to eql 1.0 }
    it { expect(subject.currency).to eql 'EUR' }

    context 'when divider is zero' do
      subject { described_class.new(10, 'EUR') / 0 }

      it 'raises ZeroDivisionError' do
        expect { subject }.to raise_error ZeroDivisionError
      end
    end
  end

  describe '#to_s' do
    context 'when amount is Fixnum' do
      subject { described_class.new(10, 'EUR').to_s }
      it { is_expected.to eql '10 EUR' }
    end

    context 'when amount is Bignum' do
      subject { described_class.new(999_999_999_999_999_999_999, 'EUR').to_s }
      it { is_expected.to eql '999999999999999999999 EUR' }
    end

    context 'when amount is Float' do
      subject { described_class.new(5.5555, 'EUR').to_s }
      it { is_expected.to eql '5.56 EUR' }
    end
  end
end
