class ForexController < ApplicationController
  def index
    response = get_http_response("https://www.freeforexapi.com/api/live")

    render json: response.body
  end

  def get_currency_pair
    pair = params[:pairs]
    response = get_http_response("https://www.freeforexapi.com/api/live?pairs=#{pair}")

    json = JSON.parse(response.body)

    if json['rates'].nil?
      render json: "Add parameters\n FORMAT: ?pairs=EURUSD"
    else
      render json: response.body
    end
  end

  def convert
    pair = params[:pairs]

    response = get_http_response("https://www.freeforexapi.com/api/live?pairs=#{pair}")

    json = JSON.parse(response.body)

    amount = params[:amount]
    currency_rate = json['rates']["#{pair}"]['rate']

    conversion = convert_currency(amount, currency_rate)

    render json: conversion
  end

  private

  def get_http_response(remote_url)
    url = URI(remote_url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.get(url)
  end

  def convert_currency(amount, currency_rate)
    conversion = amount.to_f * currency_rate.to_f
  end
end
