class ForexConverter
  def initialize(from, to, amount)
    @from = from
    @to = to
    @amount = amount
  end
  
  def convert
    pair = @from + @to

    currency = ForexPair.new(pair).get_currency(pair)

    if currency == ForexPair::ERROR_MESSAGE
      "Can't convert from #{@from} to #{@to}"
    else
      "#{@amount} #{@from} = #{convert_currency(@amount, currency.rate)} #{@to}"
    end
  end
  
  private
  
  def convert_currency(amount, currency_rate)
    amount.to_f * currency_rate.to_f
  end
end
  