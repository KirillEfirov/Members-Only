class ForexController < ApplicationController
  def index
    response = get_http_response("https://www.freeforexapi.com/api/live")

    render json: response.body
  end

  def get_currency_pair
    pair = params[:pairs]
    response = get_http_response("https://www.freeforexapi.com/api/live?pairs=#{pair}")

    render json: response.body
  end

  private

  def get_http_response(remote_url)
    url = URI(remote_url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.get(url)
  end
end


=begin
  def show_pairs
    pairs = params[:pairs]
    url = URI("https://www.freeforexapi.com/api/live?pairs=#{pairs}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    response = http.get(url)

    json = JSON.parse(response.body)
    rate = json['rates']["#{pairs}"]['rate']

    how_much = params[:how_much]

    exchange = how_much.to_f * rate.to_f

    render json: exchange
  end
=end
