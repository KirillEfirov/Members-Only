class ForexPair
  def initialize(params)
    pair = params
  end

  def get_currency(pair)
    if currency_in_db?(pair)
      get_currency_from_db(pair)
    else
      currency_pair = get_currency_from_api(pair, "https://www.freeforexapi.com/api/live?pairs=#{pair}")
      save_currency(pair, currency_pair["rates"]["#{pair}"]["rate"])
      currency_pair
    end
  end

  private

  def currency_in_db?(currency_pair)
    Currency.where(pair: currency_pair).exists?
  end

  def get_currency_from_db(currency_pair)
    Currency.find_by(pair: currency_pair)
  end

  def get_currency_from_api(currency_pair, remote_url)
    response = get_http_response(remote_url)
    JSON.parse(response.body)
  end

  def save_currency(currency_pair, currency_rate)
    Currency.create(pair: currency_pair, rate: currency_rate)
  end

  def get_http_response(remote_url)
    url = URI(remote_url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.get(url)
  end
end