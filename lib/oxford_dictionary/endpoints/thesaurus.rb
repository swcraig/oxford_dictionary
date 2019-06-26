require 'oxford_dictionary/endpoints/endpoint'

module OxfordDictionary
  module Endpoints
    # Interface for the /thesaurus endpoint
    #
    # API documentation can be found here:
    # https://developer.oxforddictionaries.com/documentation
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
