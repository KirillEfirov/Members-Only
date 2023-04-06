# frozen_string_literal: true

class ForexPair
  ERROR_MESSAGE = 'Currency is not found'
  API_URL = 'https://www.freeforexapi.com/api/live'
  RATES = 'rates'
  RATE = 'rate'

  class << self
    def call(pair)
      if Currency.where('updated_at >= ?', 1.hour.ago).find_by('pair = ?', pair).present?
        get_currency_from_db(pair)
      else
        get_currency_from_api(ForexPair::API_URL, { pairs: pair }, pair)
      end
    end

    private

    def get_currency_from_api(remote_url, params, pair)
      url = URI(remote_url)
      url.query = URI.encode_www_form(params)
      currency_from_api = Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
        response = http.get(url)
        JSON.parse(response.body)
      end

      if currency_from_api[ForexPair::RATES].nil?
        { error: ForexPair::ERROR_MESSAGE }
      else
        save_currency(pair, currency_from_api[ForexPair::RATES][pair][ForexPair::RATE])
        get_currency_from_db(pair)
      end
    end

    def save_currency(currency_pair, currency_rate)
      Currency.create(pair: currency_pair, rate: currency_rate)
    end

    def get_currency_from_db(pair)
      { currency: Currency.where('updated_at >= ?', 1.hour.ago).find_by('pair = ?', pair) }
    end
  end
end