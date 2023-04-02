class ForexController < ApplicationController
  def index
    @currency_pairs = ForexList.call
  end

  def show
    @pair = params[:pairs]
    currency_data = fetch_currency_data(@pair)

    currency_data[:error] ? flash[:error] = currency_data[:error] : @currency = currency_data[:currency]
  end

  def convert
    conversion = fetch_conversion_data(params[:from], params[:to], params[:amount]).convert

    conversion[:error] ? flash[:error] = conversion[:error] : @conversion = conversion[:conversion]
  end

  private

  def fetch_currency_data(pair)
    ForexPair.new(pair).get_currency
  end

  def fetch_conversion_data(from, to, amount)
    ForexConverter.new(from, to, amount).convert
  end
end
