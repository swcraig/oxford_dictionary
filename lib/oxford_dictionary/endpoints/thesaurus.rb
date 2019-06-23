require 'oxford_dictionary/endpoints/endpoint'

module OxfordDictionary
  module Endpoints
    class Thesaurus < Endpoint
      ENDPOINT = 'thesaurus'.freeze

      def thesaurus(word:, language:, params: {})
        path = "#{ENDPOINT}/#{language}/#{word}"
        uri = request_uri(path: path, params: params)

        response = @request_client.get(uri: uri)
        deserialize.call(response.body)
      end
    end
  end
end
