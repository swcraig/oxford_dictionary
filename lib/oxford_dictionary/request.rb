require 'httparty'
require 'json'
require 'plissken'

module OxfordDictionary
  # Handles all of the actual API calls
  module Request
    include HTTParty

    BASE = 'https://od-api.oxforddictionaries.com/api/v1'.freeze
    ACCEPT_TYPE = 'application/json'.freeze

    def request(endpoint, q, params)
      url = build_url(endpoint, q, params)
      resp = HTTParty.get(
        url,
        headers:
          {
            'Accept' => ACCEPT_TYPE, 'app_id' => app_id, 'app_key' => app_key
          }
      )
      JSON.parse(resp.body).to_snake_keys
    end

    def build_url(endpoint, q, params)
      params[:lang] || params[:lang] = 'en'
      url_start = "#{BASE}/#{endpoint}/#{params[:lang]}"
      if params[:q]
        "#{url_start}#{search_endpoint_url(params)}".chomp('/')
      else
        "#{url_start}/#{q}/#{finish_url(params)}".chomp('/')
      end
    end

    # The search endpoint has a slightly different url structure
    def search_endpoint_url(params)
      params[:prefix] || params[:prefix] = false
      append = ''
      if params[:translations]
        append = "/translations=#{params[:translations]}"
        params.delete(:translations)
      end
      "#{append}?#{create_query_string(params, '&')}"
    end

    def finish_url(params)
      params[:end] || create_query_string(params)
    end

    def create_query_string(params, seperator = ';')
      params.delete(:lang)
      count = 0
      query = ''
      params.each do |k, v|
        query += "#{k}=#{options(v)}"
        query += seperator if count < params.size - 1
        count += 1
      end
      query
    end

    def options(v)
      v.is_a?(Array) ? v.join(',') : v
    end
  end
end
