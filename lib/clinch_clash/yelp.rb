require 'json'
require 'http'

module ClinchClash
  class Yelp
    def initialize(config = {})
      @api_key = config[:api_key]

      @api_host = "https://api.yelp.com"
      @business_path = "/v3/businesses/"
      @search_path = "#{@business_path}search"

      @default_term = "dinner"
      @default_location = "73160"
      @search_limit = 10
    end

    def search(term, location)
      url = "#{@api_host}#{@search_path}"
      params = {
        term: term || @default_term,
        location: location || @default_location,
        limit: @search_limit
      }
      response = HTTP.auth("Bearer #{@api_key}").get(url, params: params)
      response.parse
    end
  end
end
