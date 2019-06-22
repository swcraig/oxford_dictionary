require 'oxford_dictionary/deprecated_request'
require 'oxford_dictionary/api_objects/entry_response'

module OxfordDictionary
  module Endpoints
    # Interface to '/inflections' endpoint
    module InflectionEndpoint
      include OxfordDictionary::DeprecatedRequest
      ENDPOINT = 'inflections'.freeze

      def inflection(query, params = {})
        warn '''
          Client#inflection is DEPRECATED and will become non-functional
          on June 30, 2019. Use Client#lemma instead. Reference
          github.com/swcraig/oxford-dictionary/pull/10 for for more information.
          Check out OxfordDictionary::Endpoints::Lemmas#lemma for the interface
          to use.
        '''
        EntryResponse.new(request(ENDPOINT, query, params)['results'][0])
      end
    end
  end
end
