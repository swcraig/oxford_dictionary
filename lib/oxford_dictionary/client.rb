require 'oxford_dictionary/endpoints/entry_endpoint'

module OxfordDictionary
  # The client object to interact with
  class Client
    include OxfordDictionary::Endpoints::EntryEndpoint

    attr_reader :app_id, :app_key

    def initialize(params)
      unless params.is_a?(Hash) && params.key?(:app_id) && params.key?(:app_key)
        raise(ArgumentError, 'API id and key required.')
      end
      params.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end
  end
end
