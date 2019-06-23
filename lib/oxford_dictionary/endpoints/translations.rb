require 'oxford_dictionary/deserialize'

module OxfordDictionary
  module Endpoints
    class Translations
      ENDPOINT = 'translations'.freeze

      def initialize(request_client:)
        @request_client = request_client
      end

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

      private

      def deserialize
        @deserialize ||= OxfordDictionary::Deserialize.new
      end
    end
  end
end
