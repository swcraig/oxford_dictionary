require 'json'
require 'net/http'
require 'plissken'
require 'oxford_dictionary/error'

module OxfordDictionary
  # Handles all of the actual API calls
  module DeprecatedRequest
    BASE = 'https://od-api.oxforddictionaries.com/api/v1'.freeze
    HTTP_OK = '200'.freeze
    ACCEPT_TYPE = 'application/json'.freeze
    # May be used by the wordlist endpoint
    ADVANCED_FILTERS = [:exact, :exclude, :exclude_senses,
                        :exclude_prime_senses, :limit, :offset,
                        :prefix, :word_length].freeze

    def request(endpoint, q, params)
      url = URI(build_url(endpoint, q, params))
      response = Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
        request = build_get_request(url)
        http.request(request)
      end
      parse_body_or_raise(response)
    end

    private

    def parse_body_or_raise(response)
      unless response.code == HTTP_OK
        raise(Error.new(response.code), error_message(response.body))
      end
      JSON.parse(response.body).to_snake_keys
    end

    def build_url(endpoint, q, params)
      params[:lang] || params[:lang] = 'en'
      url_start = "#{BASE}/#{endpoint}/#{params[:lang]}"
      if params[:q]
        "#{url_start}#{search_endpoint_url(params)}".chomp('/')
      else
        unless q
          # The wordlist endpoint uses a slightly different url structure
          return "#{url_start}/#{build_advanced_url(params)}".chomp('/')
        end
        "#{url_start}/#{q}/#{finish_url(params)}".chomp('/')
      end
    end

    def build_advanced_url(params)
      advanced_params = {}
      params.each do |k, v|
        if ADVANCED_FILTERS.include?(k)
          params.delete(k)
          advanced_params[k] = v
        end
      end
      "#{create_query_string(params)}#{advanced_query(advanced_params)}"
    end

    def advanced_query(params)
      unless params.empty?
        params[:exact] || params[:exact] = false
        return "?#{create_query_string(params, '&')}"
      end
      ''
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
      if v.is_a?(Array)
        hash_element?(v[0]) ? query_from_hash(v) : v.join(',')
      else
        v
      end
    end

    def query_from_hash(hash)
      query = ''
      hash.each { |h| query += create_query_string(h) }
      query
    end

    # Remove <p> and </p> in error message
    def error_message(response)
      response.lines.last.chomp[3..-5]
    end

    # The wordlist endpoint may nest filters
    def hash_element?(element)
      element.is_a?(Hash)
    end

    def build_get_request(url)
      request = Net::HTTP::Get.new(url)
      request['Accept'] = ACCEPT_TYPE
      request['app_id'] = app_id
      request['app_key'] = app_key
      request
    end
  end
end
