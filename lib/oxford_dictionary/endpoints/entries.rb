require 'oxford_dictionary/endpoints/endpoint'
require 'plissken'

module OxfordDictionary
  module Endpoints
    # Interface for the /entries endpoint
    #
    # API documentation can be found here:
    # https://developer.oxforddictionaries.com/documentation
    class Entries < Endpoint
      ENDPOINT = 'entries'.freeze

      # Return all the entries for a word
      #
      # @param [String] word the word to search for
      # @param [String] dataset the dataset to search in
      # @param [Hash] params the query parameters in the request
      #
      # @example Search for all domains of 'vapid' from the en-gb dataset
      #   entry(word: 'vapid', dataset: 'en-gb', params: { fields: 'domains' })
      #
      # @return [OpenStruct] the JSON response parsed into an OpenStruct
      def entry(word:, dataset:, params: {})
        path = "#{ENDPOINT}/#{dataset}/#{word}"
        uri = request_uri(path: path, params: params)

        response = @request_client.get(uri: uri)
        deserialize.call(response.body)
      end
    end
  end
end
