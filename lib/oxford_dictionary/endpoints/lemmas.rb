require 'oxford_dictionary/endpoints/endpoint'

module OxfordDictionary
  module Endpoints
    class Lemmas < Endpoint
      ENDPOINT = 'lemmas'.freeze

      def lemma(word:, language:, params: {})
        query_string = "#{ENDPOINT}/#{language}/#{word}"
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
