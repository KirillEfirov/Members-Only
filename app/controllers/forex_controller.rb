class ForexController < ApplicationController
  def index
    url = URI("https://www.freeforexapi.com/api/live")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    response = http.get(url)

    render json: response.body
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
