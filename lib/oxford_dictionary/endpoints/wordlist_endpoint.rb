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
        # Check first so that we don't waste an API call
        if too_many_filter_values(params)
          raise(Error.new(400), 'Do not use more than 5 values for a filter')
        end
        ListResponse.new(request(ENDPOINT, nil, params))
      end

      private

      def too_many_filter_values(params)
        params.each do |k, v|
          return true if v.size > 5 && !ADVANCED_FILTERS.include?(k)
        end
        false
      end
    end
  end
end
