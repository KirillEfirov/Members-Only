# frozen_string_literal: true

module Forex
  class ForexList
    API_URL = 'https://www.freeforexapi.com/api/live'
    PAIRS_KEY = 'supportedPairs'
  
    class << self
      def call
        response = get_http_response(ForexList::API_URL)
        currencies = JSON.parse(response.body)
        currencies[ForexList::PAIRS_KEY]
      end
  
      private
  
      def get_http_response(remote_url)
        url = URI(remote_url)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.get(url)
      end
    end
  end
end
