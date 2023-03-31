class ForexConverter
    def initialize(params)
      @from = params[:from]
      @to = params[:to]
      @amount = params[:amount]
    end
  
    def convert
      pair = @from + @to
  
      response = get_http_response("https://www.freeforexapi.com/api/live?pairs=#{pair}")
      currency = JSON.parse(response.body)
  
      rate = currency["rates"]["#{pair}"]["rate"]
  
      "#{@amount} #{pair[0..2]} = #{convert_currency(@amount, rate)} #{pair[3..5]}\nrate: #{currency["rates"]["#{pair}"]["rate"]}"
    end
  
    private
  
    def get_http_response(remote_url)
      url = URI(remote_url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.get(url)
    end
  
    def convert_currency(amount, currency_rate)
      amount.to_f * currency_rate.to_f
    end
  end
  