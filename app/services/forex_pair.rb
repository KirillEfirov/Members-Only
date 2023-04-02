class ForexPair
  ERROR_MESSAGE = "Currency is not found"
  API_URL = "https://www.freeforexapi.com/api/live"

  def initialize(params)
    @pair = params
  end

  def get_currency
    if currency_in_db?
      last_updation = find_last_updation
      
      if last_updation >= 1.hour.ago
        { currency: @currency }
      else
        currency_pair = get_currency_from_api(ForexPair::API_URL, { pairs: @pair })
        update_currency(@currency, currency_pair["rates"][@pair]["rate"])
        { currency: @currency }
      end

    else
      currency_pair = get_currency_from_api(ForexPair::API_URL, { pairs: @pair })

      if currency_pair["rates"].nil?
        { error: ForexPair::ERROR_MESSAGE }
      else
        save_currency(@pair, currency_pair["rates"][@pair]["rate"])
        { currency: @currency }
      end
    end
  end

  private

  def currency_in_db?
    @currency ||= Currency.find_by(pair: @pair)
  end

  def find_last_updation
    @currency.updated_at
  end

  def save_currency(currency_pair, currency_rate)
    @currency = Currency.create(pair: currency_pair, rate: currency_rate)
  end

  def update_currency(currency_pair, currency_rate)
    @currency.update(rate: currency_rate)
  end

  def get_currency_from_api(remote_url, params)
    url = URI(remote_url)
    url.query = URI.encode_www_form(params)
    Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
      response = http.get(url)
      JSON.parse(response.body)
    end
  end
end
