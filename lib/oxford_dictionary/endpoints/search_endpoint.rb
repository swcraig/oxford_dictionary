require 'oxford_dictionary/deprecated_request'
require 'oxford_dictionary/api_objects/list_response'

module OxfordDictionary
  module Endpoints
    # Interface to '/search' endpoint
    module SearchEndpoint
      include OxfordDictionary::DeprecatedRequest
      ENDPOINT = 'search'.freeze

      def search(query, params = {})
        warn '''
        Client#search without using named parameters is DEPRECATED and will
        become non-functional on June 30, 2019 (it uses the V1 interface which
        Oxford Dictionaries is taking offline). Reference
        https://github.com/swcraig/oxford-dictionary/pull/15 for more
        information. Check out OxfordDictionary::Endpoints::Search for the
        interface to use.
        '''

        params[:q] = query
        ListResponse.new(request(ENDPOINT, query, params))
      end
    end
  end
end
