require 'oxford_dictionary/endpoints/endpoint'

module OxfordDictionary
  module Endpoints
    class Search < Endpoint
      ENDPOINT = 'search'.freeze

      def search(language:, params: {})
        query_string = "#{ENDPOINT}/#{language}"
        uri = URI(query_string)

        unless params.empty?
          uri.query = URI.encode_www_form(params)
        end

        response = @request_client.get(uri: uri)
        deserialize.call(response.body)
      end

      def search_translation(source_language:, target_language:, params: {})
        query_string =
          "#{ENDPOINT}/translations/#{source_language}/#{target_language}"
        uri = URI(query_string)

        unless params.empty?
          uri.query = URI.encode_www_form(params)
        end

        response = @request_client.get(uri: uri)
        deserialize.call(response.body)
      end
    end
  end
end
