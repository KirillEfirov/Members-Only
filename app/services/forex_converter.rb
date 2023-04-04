class ForexConverter
  ERROR_MESSAGE = "Can't convert currency"

  def initialize(from, to, amount)
    @from = from
    @to = to
    @amount = amount
  end
  
  def convert
    pair = @from.to_s + @to.to_s
    currency = ForexPair.new(pair).get_currency

    if(currency == currency[:error] || currency[:currency].nil?)
      { error: ForexConverter::ERROR_MESSAGE }
    else
      { conversion: convert_currency(@amount, currency[:currency].rate) }
    end
  end
  
  private
  
  def convert_currency(amount, currency_rate)
    amount.to_f * currency_rate.to_f
  end
end
  