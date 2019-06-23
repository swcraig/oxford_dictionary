require 'oxford_dictionary/deserialize'

module OxfordDictionary
  module Endpoints
    class Sentences
      ENDPOINT = 'sentences'.freeze

      def initialize(request_client:)
        @request_client = request_client
      end

      def sentence(word:, language:, params: {})
        query_string = "#{ENDPOINT}/#{language}/#{word}"
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
