require 'oxford_dictionary/endpoints/entries'
require 'oxford_dictionary/endpoints/lemmas'
require 'oxford_dictionary/endpoints/translations'
require 'oxford_dictionary/endpoints/sentences'
require 'oxford_dictionary/endpoints/thesaurus'
require 'oxford_dictionary/endpoints/search'

require 'oxford_dictionary/request'

module OxfordDictionary
  # Our client class to interface with the different API endpoints
  # This should be, in general, the only touchpoint for library use
  #
  # OxfordDictionary::Client.new is also aliased to OxfordDictionary.new
  class Client
    attr_reader :app_id, :app_key

    def initialize(params)
      unless params.is_a?(Hash) && params.key?(:app_id) && params.key?(:app_key)
        raise(ArgumentError, 'API id and key required.')
      end
      params.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def entry(word:, dataset:, params:)
      entry_endpoint.entry(word: word, dataset: dataset, params: params)
    end

    def lemma(word:, language:, params: {})
      lemma_endpoint.lemma(word: word, language: language, params: params)
    end

    def translation(word:, source_language:, target_language:, params: {})
      translation_endpoint.translation(
        word: word,
        source_language: source_language,
        target_language: target_language,
        params: params
      )
    end

    def sentence(word:, language:, params: {})
      sentence_endpoint.sentence(word: word, language: language, params: params)
    end

    def thesaurus(word:, language:, params: {})
      thesaurus_endpoint.thesaurus(
        word: word,
        language: language,
        params: params
      )
    end

    def search(*args)
      if args.first.is_a?(Hash)
        args = args.first
        search_endpoint.search(language: args[:language], params: args[:params])
      else
        warn '''
          Client#search without parameters is DEPRECATED.
          Use the new V2 interface for this
          method instead. Reference github.com/swcraig/oxford-dictionary/pull/15
          for more information. Specifically check out
          OxfordDictionary::Endpoints::Search#search for the new interface.
        '''

        language_parameter = args[1].is_a?(Hash) && args[1][:lang]
        language = language_parameter || 'en-gb'
        args[1].delete(:lang) if language_parameter

        if args[1].is_a?(Hash) && args[1][:translations]
          target_language = args[1][:translations]
          args[1].delete(:translations)

          params = args[1]&.map do |key, value|
            if value.is_a?(Array)
              [key, value.join(',')]
            else
              [key, value]
            end
          end.to_h
          parameters = params&.merge(q: args[0]) || {}
          search_translation(
            source_language: language,
            target_language: target_language,
            params: parameters
          )
        else
          params = args[1]&.map do |key, value|
            if value.is_a?(Array)
              [key, value.join(',')]
            else
              [key, value]
            end
          end.to_h
          parameters = params&.merge(q: args[0]) || {}
          search_endpoint.search(language: language, params: parameters)
        end
      end
    end

    def search_translation(source_language:, target_language:, params: {})
      search_endpoint.search_translation(
        source_language: source_language,
        target_language: target_language,
        params: params
      )
    end

    private

    def lemma_endpoint
      @lemma_endpoint ||=
        OxfordDictionary::Endpoints::Lemmas.new(request_client: request_client)
    end

    def translation_endpoint
      @translation_endpoint ||= OxfordDictionary::Endpoints::Translations.new(
        request_client: request_client
      )
    end

    def entry_endpoint
      @entry_endpoint ||=
        OxfordDictionary::Endpoints::Entries.new(request_client: request_client)
    end

    def sentence_endpoint
      @sentence_endpoint ||= OxfordDictionary::Endpoints::Sentences.new(
        request_client: request_client
      )
    end

    def search_endpoint
      @search_endpoint ||= OxfordDictionary::Endpoints::Search.new(
        request_client: request_client
      )
    end

    def thesaurus_endpoint
      @thesaurus_endpoint ||= OxfordDictionary::Endpoints::Thesaurus.new(
        request_client: request_client
      )
    end

    def request_client
      @request_client ||=
        OxfordDictionary::Request.new(app_id: @app_id, app_key: @app_key)
    end
  end
end
