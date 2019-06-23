require 'oxford_dictionary/deserialize'

module OxfordDictionary
  module Endpoints
    class Endpoint
      def initialize(request_client:)
        @request_client = request_client
      end

      private

      def deserialize
        @deserialize ||= OxfordDictionary::Deserialize.new
      end
    end
  end
end
