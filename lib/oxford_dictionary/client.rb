require 'oxford_dictionary/endpoints/entry_endpoint'
require 'oxford_dictionary/endpoints/inflection_endpoint'
require 'oxford_dictionary/endpoints/search_endpoint'
require 'oxford_dictionary/endpoints/wordlist_endpoint'

module OxfordDictionary
  # The client object to interact with
  class Client
    include OxfordDictionary::Endpoints::EntryEndpoint
    include OxfordDictionary::Endpoints::InflectionEndpoint
    include OxfordDictionary::Endpoints::SearchEndpoint
    include OxfordDictionary::Endpoints::WordlistEndpoint

    attr_reader :app_id, :app_key

    def initialize(params)
      unless params.is_a?(Hash) && params.key?(:app_id) && params.key?(:app_key)
        raise(ArgumentError, 'API id and key required.')
      end
      params.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def entry(*args)
      if args.first.is_a?(Hash)
        args = args.first
          entry_endpoint.entry(
            word: args[:word],
            dataset: args[:dataset],
            params: args[:params]
          )
      else
        warn '''
          The V1 interface for this library is DEPRECATED and will become
          non-functional on June 30, 2019. Use the new V2 interface for this
          method instead. Reference github.com/swcraig/oxford-dictionary/pull/8
          for more information. Specifically check out
          OxfordDictionary::Endpoints::Entries#entry for the new interface.
        '''
        # Support V1 behaviour
        super(*args)
      end
    end

    private

    def entry_endpoint
      @entry_endpoint ||=
        OxfordDictionary::Endpoints::Entries.new(request_client: request_client)
    end

    def request_client
      @request_client ||=
        OxfordDictionary::Request.new(app_id: @app_id, app_key: @app_key)
    end
  end
end
