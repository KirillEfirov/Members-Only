class ForexConverter
    def initialize(from, to, amount)
      @from = from
      @to = to
      @amount = amount
    end
  
    def convert
      pair = @from + @to
  
      currency = get_currency_from_api(pair, "https://www.freeforexapi.com/api/live?pairs=#{pair}")

      if currency["rates"].nil?
        "Can't convert from #{@from} to #{@to}"
      else
        rate = currency["rates"]["#{pair}"]["rate"]
        "#{@amount} #{pair[0..2]} = #{convert_currency(@amount, rate)} #{pair[3..5]}\nrate: #{currency["rates"]["#{pair}"]["rate"]}"
      end
    end
  
    private
  
    def get_http_response(remote_url)
      url = URI(remote_url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.get(url)
    end

    def get_currency_from_api(currency_pair, remote_url)
      response = get_http_response(remote_url)
      JSON.parse(response.body)
    end
  
    def convert_currency(amount, currency_rate)
      amount.to_f * currency_rate.to_f
    end
  end
  