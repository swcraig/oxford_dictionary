require 'oxford_dictionary/request'
require 'oxford_dictionary/api_objects/entry_response'

module OxfordDictionary
  module Endpoints
    # Interface to '/inflections' endpoint
    module InflectionEndpoint
      include OxfordDictionary::Request
      ENDPOINT = 'inflections'.freeze

      def inflection(query, params = {})
        EntryResponse.new(request(ENDPOINT, query, params)['results'][0])
      end
    end
  end
end
