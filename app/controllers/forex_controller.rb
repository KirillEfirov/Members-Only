class ForexController < ApplicationController
  def index
    response = get_http_response("https://www.freeforexapi.com/api/live")

    json = JSON.parse(response.body)
    @currency_pairs = json["supportedPairs"]
  end

  def show
    pair = params[:pairs]

    if Currency.where(pair: pair).exists?
      currency = Currency.find_by(pair: pair)
      show_currency(pair, currency)
    else
      response = get_http_response("https://www.freeforexapi.com/api/live?pairs=#{pair}")
      currency_pair = JSON.parse(response.body)

      if currency_pair["rates"].nil?
        render json: "Currency is not found"
      else
        Currency.create(pair: pair, rate: currency_pair["rates"]["#{pair}"]["rate"])
        render json: currency_pair
      end
    end
  end

  def convert
    pair = params[:pairs]
    amount = params[:amount]

    response = get_http_response("https://www.freeforexapi.com/api/live?pairs=#{pair}")
    currency = JSON.parse(response.body)

    if currency["rates"].nil?
      render json: { error: "Currency is not found" }, status: :not_found
    else
      currency_rate = currency["rates"]["#{pair}"]["rate"]
      render json: convert_currency(amount, currency_rate)
    end
  end

  private

  def get_http_response(remote_url)
    url = URI(remote_url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.get(url)
  end

  def convert_currency(amount, currency_rate)
    amount.to_f * currency_rate.to_f
  end

  def show_currency(pair_param, currency)
    if currency.present? && currency.created_at >= 1.hour.ago
      render json: Currency.where(pair: pair_param)
    else
      response = get_http_response("https://www.freeforexapi.com/api/live?pairs=#{pair_param}")
      currency_pair = JSON.parse(response.body)

      if currency_pair["rates"].nil?
        render json: { error: "Currency is not found" }, status: :not_found
      else
        currency ||= Currency.new(pair: pair_param)
        currency.update!(rate: currency_pair["rates"][pair_param]["rate"])
        render json: currency_pair
      end
    end
  end
end
