# frozen_string_literal: true

module Forex
  class ForexConverter
    ERROR_MESSAGE = 'Can\'t convert currency'

    class << self
      def call(from, to, amount)
        pair = [from, to].join
        currency = ForexPair.call(pair)

        if currency == currency[:error] || currency[:currency].nil?
          { error: ForexConverter::ERROR_MESSAGE }
        else
          { conversion: convert_currency(amount, currency[:currency].rate) }
        end
      end

      private

      def convert_currency(amount, currency_rate)
        amount.to_f * currency_rate
      end
    end
  end
end
