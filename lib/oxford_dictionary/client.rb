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
        raise(ArgumentError, 'app_id and app_key arguments required.')
      end
      params.each { |key, value| instance_variable_set("@#{key}", value) }
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

    def search(language:, params:)
      search_endpoint.search(language: language, params: params)
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
