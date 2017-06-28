require 'json'
require 'http'

module ClinchClash
  class Yelp
    def initialize(config = {})
      @client_id = config[:client_id]
      @client_secret = config[:client_secret]

      @api_host = "https://api.yelp.com"
      @business_path = "/v3/businesses/"
      @search_path = "#{@business_path}search"
      @token_path = "/oauth2/token"
      @grant_type = "client_credentials"

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
      response = HTTP.auth(bearer_token()).get(url, params: params)
      response.parse
    end

    private

    def bearer_token
      url = "#{@api_host}#{@token_path}"
      params = {
        client_id: @client_id,
        client_secret: @client_secret,
        grant_type: @grant_type
      }
      response = HTTP.post(url, params: params)
      parsed_response = response.parse
      "#{parsed_response['token_type']} #{parsed_response['access_token']}"
    end
  end
end