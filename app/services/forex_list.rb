class ForexList
  def self.call
    supported_pairs
  end

  private

  def self.supported_pairs
    response = self.get_http_response("https://www.freeforexapi.com/api/live")
    currencies = JSON.parse(response.body)
    currencies["supportedPairs"]
  end

  def self.get_http_response(remote_url)
    url = URI(remote_url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.get(url)
  end
end
