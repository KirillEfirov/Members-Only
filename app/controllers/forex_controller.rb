class ForexController < ApplicationController
  def index
    @currency_pairs = ForexList.call
  end

  def show
    @pair = params[:pairs]
    forex_pair = ForexPair.new(@pair)
    currency_data = forex_pair.get_currency(@pair)

    if currency_data[:error]
      flash[:error] = currency_data[:error]
    else
      @currency = currency_data[:currency]
    end
  end

  def convert
    conversion = ForexConverter.new(params[:from], params[:to], params[:amount]).convert

    if conversion[:error]
      flash[:error] = conversion[:error]
    else
      @conversion = conversion[:conversion]
    end
  end
end
