# frozen_string_literal: true

require 'oxford_dictionary/request'
require 'oxford_dictionary/api_objects/word_frequency_response'

module OxfordDictionary
  module Endpoints
    # Interface to 'stats/frequency/word' endpoint
    module WordFrequencyEndpoint
      include OxfordDictionary::Request
      ENDPOINT = 'stats/frequency/word'

      def word_frequency(params = {})
        WordFrequencyResponse.new(request(ENDPOINT, nil, params))
      end
    end
  end
end
