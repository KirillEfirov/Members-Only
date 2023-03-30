class ForexController < ApplicationController
  def index
    response = get_http_response("https://www.freeforexapi.com/api/live")

    json = JSON.parse(response.body)
    @currency_pairs = json["supportedPairs"]
  end

  def show
    pair = params[:pairs]

    if Currency.where(pair: pair).exists?
      #render json: Currency.where(pair: pair)
      show_if_in_db()
    else
      response = get_http_response("https://www.freeforexapi.com/api/live?pairs=#{pair}")
      currency_pair = JSON.parse(response.body)

      if currency_pair["rates"].nil?
        render json: "Currency doesn't exist"
      else
        currency_to_db = Currency.create(pair: pair, rate: currency_pair["rates"]["#{pair}"]["rate"])
        render json: currency_pair
      end
    end
  end

  def convert
    pair = params[:pairs]

    response = get_http_response("https://www.freeforexapi.com/api/live?pairs=#{pair}")
    json = JSON.parse(response.body)

    amount = params[:amount]
    currency_rate = json["rates"]["#{pair}"]["rate"]

    render json: convert_currency(amount, currency_rate)
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

  def show_if_in_db()
    my_object = Currency.find_by(pair: params[:pairs])

    if my_object && my_object.created_at >= 1.hour.ago
      render json: Currency.where(pair: params[:pairs])
    else
      response = get_http_response("https://www.freeforexapi.com/api/live?pairs=#{pair}")
      currency_pair = JSON.parse(response.body)

      if currency_pair["rates"].nil?
        render json: "Currency doesn't exist"
      else
        currency_to_db = Currency.update(rate: currency_pair["rates"]["#{pair}"]["rate"])
        render json: currency_pair
      end
    end
  end
end
