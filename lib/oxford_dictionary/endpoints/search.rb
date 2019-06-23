require 'oxford_dictionary/endpoints/endpoint'

module OxfordDictionary
  module Endpoints
    class Search < Endpoint
      ENDPOINT = 'search'.freeze

      def search(language:, params: {})
        path = "#{ENDPOINT}/#{language}"
        uri = request_uri(path: path, params: params)

        response = @request_client.get(uri: uri)
        deserialize.call(response.body)
      end

      def search_translation(source_language:, target_language:, params: {})
        path = "#{ENDPOINT}/translations/#{source_language}/#{target_language}"
        uri = request_uri(path: path, params: params)

        response = @request_client.get(uri: uri)
        deserialize.call(response.body)
      end
    end
  end
end
