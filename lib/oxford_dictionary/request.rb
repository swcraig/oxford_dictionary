require 'httparty'
require 'json'
require 'hashie'
require 'plissken'

# Use plissken? 1.0.0

module OxfordDictionary
  # Handles all of the actual API calls
  module Request
    include HTTParty

    BASE = 'https://od-api.oxforddictionaries.com/api/v1'.freeze
    ACCEPT_TYPE = 'application/json'.freeze

    def request(endpoint, q, params)
      lang = params.key?(:lang) ? params[:lang] : 'en'
      url = "#{BASE}/#{endpoint}/#{lang}/#{q}/#{finish_url(params)}".chomp('/')
      resp = HTTParty.get(
        url,
        headers:
          {
            'Accept' => ACCEPT_TYPE, 'app_id' => app_id, 'app_key' => app_key
          }
      )
      Hashie::Mash.new(JSON.parse(resp.body).to_snake_keys).results.first
    end

    def finish_url(params)
      params[:end] || create_query_string(params)
    end

    def create_query_string(params)
      params.delete(:lang)
      count = 0
      query = ''
      params.each do |k, v|
        query += "#{k}=#{options(v)}"
        query += ';' if count < params.size - 1
        count += 1
      end
      query
    end

    def options(v)
      v.is_a?(Array) ? v.join(',') : v
    end
  end
end
