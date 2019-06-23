require 'oxford_dictionary/endpoints/endpoint'

module OxfordDictionary
  module Endpoints
    class Translations < Endpoint
      ENDPOINT = 'translations'.freeze

      def translation(word:, source_language:, target_language:, params: {})
        query_string =
          "#{ENDPOINT}/#{source_language}/#{target_language}/#{word}"
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
