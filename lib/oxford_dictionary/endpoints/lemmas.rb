require 'oxford_dictionary/endpoints/endpoint'

module OxfordDictionary
  module Endpoints
    # Interface for the /lemmas endpoint
    #
    # API documentation can be found here:
    # https://developer.oxforddictionaries.com/documentation
    class Lemmas < Endpoint
      ENDPOINT = 'lemmas'.freeze

      # Returns all possible lemmas for a word
      #
      # @param [String] word the inflected word to search for
      # @param [String] language the language to search in
      # @param [Hash] params the query parameters in the request
      #
      # @example Search for the verb lemmas of 'running' in 'en'
      #   lemma(
      #     word: 'running',
      #     language: 'en',
      #     params: { lexicalCategory: 'verb' }
      #   )
      #
      # @return [OpenStruct] the JSON response parsed into an OpenStruct
      def lemma(word:, language:, params: {})
        path = "#{ENDPOINT}/#{language}/#{word}"
        uri = request_uri(path: path, params: params)

        response = @request_client.get(uri: uri)
        deserialize.call(response.body)
      end
    end
  end
end
