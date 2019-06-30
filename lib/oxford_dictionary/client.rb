require 'oxford_dictionary/endpoints/entries'
require 'oxford_dictionary/endpoints/lemmas'
require 'oxford_dictionary/endpoints/translations'
require 'oxford_dictionary/endpoints/sentences'
require 'oxford_dictionary/endpoints/thesaurus'
require 'oxford_dictionary/endpoints/search'

require 'oxford_dictionary/request'

module OxfordDictionary
  # The client object to interact with
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
        # Try our best
        dataset = args[1].is_a?(Hash) && args[1][:lang] || 'en-gb'
        entry(word: args.first, dataset: dataset, params: {})
      end
    end

    def entry_definitions(*args)
      deprecated_method
      dataset = args[1].is_a?(Hash) && args[1][:lang] || 'en-gb'
      entry(
        word: args.first,
        dataset: dataset,
        params: { fields: 'definitions' }
      )
    end

    def entry_examples(*args)
      deprecated_method
      dataset = args[1].is_a?(Hash) && args[1][:lang] || 'en-gb'
      entry(
        word: args.first,
        dataset: dataset,
        params: { fields: 'examples' }
      )
    end

    def entry_pronunciations(*args)
      deprecated_method
      dataset = args[1].is_a?(Hash) && args[1][:lang] || 'en-gb'
      entry(
        word: args.first,
        dataset: dataset,
        params: { fields: 'pronunciations' }
      )
    end

    def entry_sentences(*args)
      deprecated_method
      dataset = args[1].is_a?(Hash) && args[1][:lang] || 'en-gb'
      entry(
        word: args.first,
        dataset: dataset,
        params: { fields: 'sentences' }
      )
    end

    def entry_antonyms(*args)
      deprecated_method
      thesaurus(
        word: args.first,
        language: 'en',
        params: { fields: 'antonyms' }
      )
    end

    def entry_synonyms(*args)
      deprecated_method
      thesaurus(
        word: args.first,
        language: 'en',
        params: { fields: 'synonyms' }
      )
    end

    def entry_antonyms_synonyms(*args)
      deprecated_method
      thesaurus(
        word: args.first,
        language: 'en',
        params: { fields: 'antonyms,synonyms' }
      )
    end

    def entry_translations(*args)
      deprecated_method
      translation(
        word: args.first,
        source_language: 'en-us',
        target_language: args[1][:translations],
        params: {}
      )
    end

    def entry_snake_case(word:, dataset:, params: {})
      warn 'Client#entry_snake_case is DEPRECATED. Use Client#entry instead.'
      entry_endpoint.
        entry_snake_case(word: word, dataset: dataset, params: params)
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
          Using the method without named parameters will become
          non-functional on June 30, 2019. Use the new V2 interface for this
          method instead. Reference github.com/swcraig/oxford-dictionary/pull/15
          for more information. Specifically check out
          OxfordDictionary::Endpoints::Search#search for the new interface.
        '''
        if args[1].is_a?(Hash) && args[1][:translations]
          super(args[0], translations: args[1][:translations])
        else
          super(*args)
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

    def inflection(*args)
      deprecated_method
      lemma(word: args.first, language: 'en', params: {})
    end

    private

    def deprecated_method
      warn '''
      '''
    end

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
