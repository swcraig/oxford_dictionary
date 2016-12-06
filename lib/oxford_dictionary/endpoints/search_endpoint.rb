require 'oxford_dictionary/request'
require 'oxford_dictionary/api_objects/list_response'

module OxfordDictionary
  module Endpoints
    # Interface to '/search' endpoint
    module SearchEndpoint
      include OxfordDictionary::Request
      ENDPOINT = 'search'.freeze

      def search(query, params = {})
        params[:q] = query
        ListResponse.new(request(ENDPOINT, query, params))
      end
    end
  end
end
