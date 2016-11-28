require 'oxford_dictionary/request'

module OxfordDictionary
  module Endpoint
    # Interface to '/entries' endpoint
    module EntryEndpoint
      include OxfordDictionary::Request
      ENDPOINT = 'entries'.freeze

      def entry(query, params = {})
        entry_request(query, params)
      end

      def entry_definitions(query, params = {})
        params[:end] = 'definitions'
        entry_request(query, params)
      end

      def entry_examples(query, params = {})
        params[:end] = 'examples'
        entry_request(query, params)
      end

      def entry_pronunciations(query, params = {})
        params[:end] = 'pronunciations'
        entry_request(query, params)
      end

      def entry_request(query, params)
        request(ENDPOINT, query, params)
      end
    end
  end
end
