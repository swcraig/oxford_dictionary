require 'oxford_dictionary/request'
require 'oxford_dictionary/api_objects/list_response'

module OxfordDictionary
  module Endpoints
    # Interface to '/wordlist' endpoint
    module WordlistEndpoint
      include OxfordDictionary::Request
      ENDPOINT = 'wordlist'.freeze
      ADVANCED_FILTERS = [:exact, :exclude, :exclude_senses,
                          :exclude_prime_senses, :limit, :offset,
                          :prefix, :word_length].freeze

      def wordlist(params = {})
        # If there are more than 5 filters the request is not valid
        ListResponse.new(request(ENDPOINT, nil, params))
      end
    end
  end
end
