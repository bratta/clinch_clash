# frozen_string_literal: true

require 'json'
require 'http'

module ClinchClash
  # Simple Yelp API
  class Yelp
    def initialize(api_key)
      @api_key = api_key
      @api_host = 'https://api.yelp.com'
      @search_path = '/v3/businesses/search'
    end

    def search(search_term = 'restaurants', zipcode = '73160')
      response = get_businesses(search_term, zipcode)
      if response['error']
        puts "Error searching Yelp: #{response['error']['text']}"
        exit
      end
      build_business_results(response)
    end

    def get_businesses(search_term = 'restaurants', location = '73160', limit = 10)
      url = "#{@api_host}#{@search_path}"
      params = {
        term: search_term,
        location: location,
        limit: limit
      }
      response = HTTP.auth("Bearer #{@api_key}").get(url, params: params)
      response.parse
    end

    private

    def build_business_results(response)
      [].tap do |results|
        if response && response['businesses']
          response['businesses'].each do |business|
            results << {
              name: business['name'], rating: business['rating'], url: business['url']
            }
          end
        end
      end
    end
  end
end
