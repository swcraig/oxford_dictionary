require 'httparty'
require 'json'
require 'hashie'

module OxfordDictionary
  # Handles all of the actual API calls
  module Request
    include HTTParty

    BASE_URI = 'https://od-api.oxforddictionaries.com/api/v1'.freeze
    ACCEPT_TYPE = 'application/json'.freeze

    def request(endpoint, query, params)
      lang = params.key?(:lang) ? params[:lang] : 'en'
      url = "#{BASE_URI}/#{endpoint}/#{lang}/#{query}/#{finish_url(params)}"
      resp = HTTParty.get(
        url,
        headers:
          {
            'Accept' => ACCEPT_TYPE, 'app_id' => app_id, 'app_key' => app_key
          }
      )
      Hashie::Mash.new(JSON.parse(resp.body)).results.first
    end

    def finish_url(params)
      params.delete(:lang) if params.key?(:lang)
      if params.key?(:end)
        params[:end]
      elsif !params.empty?
        query = ''
        params.each do |k, v|
          query += "#{k}=#{v};"
        end
        query
      end
    end
  end
end
