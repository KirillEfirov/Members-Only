class ForexController < ApplicationController
  def index
    @currency_pairs = ForexList.call
  end

  def show
    @pair = params[:pairs]
    currency_data = ForexPair.call(@pair)

    currency_data[:error] ? flash[:error] = currency_data[:error] : @currency = currency_data[:currency]
  end

  def convert
    conversion = ForexConverter.call(params[:from], params[:to], params[:amount])

    conversion[:error] ? flash[:error] = conversion[:error] : @conversion = conversion[:conversion]
  end
end
