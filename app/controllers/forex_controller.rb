require_relative '../services/forex_service/forex_list'
require_relative '../services/forex_service/forex_pair'
require_relative '../services/forex_service/forex_converter'

class ForexController < ApplicationController
  include Forex

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
