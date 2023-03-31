class ForexController < ApplicationController
  def index
    @currency_pairs = ForexList.call
  end

  def show
    forex_pair = ForexPair.new(params[:pairs])
    render json: forex_pair.get_currency(params[:pairs])
  end

  def convert
    render json: ForexConverter.new(params).convert
  end
end
