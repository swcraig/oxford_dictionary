require 'oxford_dictionary/endpoints/endpoint'
require 'plissken'

module OxfordDictionary
  module Endpoints
    class Entries < Endpoint
      ENDPOINT = 'entries'.freeze

      def entry(word:, dataset:, params: {})
        query_string = "#{ENDPOINT}/#{dataset}/#{word}"
        uri = URI(query_string)

        unless params.empty?
          uri.query = URI.encode_www_form(params)
        end

        response = @request_client.get(uri: uri)
        deserialize.call(response.body)
      end

      def entry_snake_case(word:, dataset:, params: {})
        query_string = "#{ENDPOINT}/#{dataset}/#{word}"
        uri = URI(query_string)

        unless params.empty?
          uri.query = URI.encode_www_form(params)
        end

        response = @request_client.get(uri: uri)
        snake_keys = JSON.parse(response.body).to_snake_keys
        deserialize.call(JSON.generate(snake_keys))
      end
    end
  end
end
