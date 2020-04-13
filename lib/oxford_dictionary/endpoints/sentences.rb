require 'oxford_dictionary/endpoints/endpoint'

module OxfordDictionary
  module Endpoints
    # Interface for the /sentences endpoint
    class Sentences < Endpoint
      ENDPOINT = 'sentences'.freeze

      def sentence(word:, language:, params: {})
        path = "#{ENDPOINT}/#{language}/#{word}"
        uri = request_uri(path: path, params: params)

        response = @request_client.get(uri: uri)
        deserialize.call(response.body)
      end
    end
  end
end
