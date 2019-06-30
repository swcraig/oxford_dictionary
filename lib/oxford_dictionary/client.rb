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
          The V1 interface for this library is DEPRECATED.
          Use the new V2 interface for this
          method instead. Reference github.com/swcraig/oxford-dictionary/pull/8
          for more information. Specifically check out
          OxfordDictionary::Endpoints::Entries#entry for the new interface.
        '''
        # Try our best
        dataset = args[1].is_a?(Hash) && args[1][:lang] || 'en-gb'
        has_lang = args[1].is_a?(Hash) && args[1][:lang]
        args[1].delete(:lang) if has_lang

          params = args[1]&.map do |key, value|
            if value.is_a?(Array)
              [key, value.join(',')]
            else
              [key, value]
            end
          end.to_h
          parameters = params || {}
        entry(word: args.first, dataset: dataset, params: parameters)
      end
    end

    def entry_definitions(*args)
      warn '''
        Client#entry_defintions is DEPRECATED.
        Use Client#entry instead. Reference
        https://github.com/swcraig/oxford-dictionary/pull/8 for more
        information. Check out OxfordDictionary::Endpoints::Entries for the
        interface to use. Specifically use it with
        params: { fields: \'definitions\' }
      '''

      dataset = args[1].is_a?(Hash) && args[1][:lang] || 'en-gb'
      entry(
        word: args.first,
        dataset: dataset,
        params: { fields: 'definitions' }
      )
    end

    def entry_examples(*args)
      warn '''
        Client#entry_examples is DEPRECATED. Use Client#entry instead. Reference
        https://github.com/swcraig/oxford-dictionary/pull/8 for more
        information. Check out OxfordDictionary::Endpoints::Entries for the
        interface to use. Specifically use it with
        params: { fields: \'examples\' }
      '''

      dataset = args[1].is_a?(Hash) && args[1][:lang] || 'en-gb'
      entry(
        word: args.first,
        dataset: dataset,
        params: { fields: 'examples' }
      )
    end

    def entry_pronunciations(*args)
      warn '''
        Client#entry_pronunciations is DEPRECATED.
        Use Client#entry instead. Reference
        https://github.com/swcraig/oxford-dictionary/pull/8 for more
        information. Check out OxfordDictionary::Endpoints::Entries for the
        interface to use. Specifically use it with
        params: { fields: \'pronunciations\' }
      '''

      dataset = args[1].is_a?(Hash) && args[1][:lang] || 'en-gb'
      entry(
        word: args.first,
        dataset: dataset,
        params: { fields: 'pronunciations' }
      )
    end

    def entry_sentences(*args)
      warn '''
        Client#entry_sentences is DEPRECATED.
        Use Client#sentence instead. Reference
        https://github.com/swcraig/oxford-dictionary/pull/13 for more
        information. Check out OxfordDictionary::Endpoints::Sentences for the
        interface to use.
      '''

      dataset = args[1].is_a?(Hash) && args[1][:lang] || 'en'
      sentence(
        word: args.first,
        language: dataset,
        params: {}
      )
    end

    def entry_antonyms(*args)
      warn '''
        Client#entry_antonyms is DEPRECATED.
        Use Client#thesaurus instead. Reference
        https://github.com/swcraig/oxford-dictionary/pull/13 for more
        information. Check out OxfordDictionary::Endpoints::Thesaurus for the
        interface to use. Specifically use it with
        params: { fields: \'antonyms\' }
      '''

      thesaurus(
        word: args.first,
        language: 'en',
        params: { fields: 'antonyms' }
      )
    end

    def entry_synonyms(*args)
      warn '''
        Client#entry_synonyms is DEPRECATED.
        Use Client#thesaurus instead. Reference
        https://github.com/swcraig/oxford-dictionary/pull/13 for more
        information. Check out OxfordDictionary::Endpoints::Thesaurus for the
        interface to use. Specifically use it with
        params: { fields: \'synonyms\' }
      '''

      thesaurus(
        word: args.first,
        language: 'en',
        params: { fields: 'synonyms' }
      )
    end

    def entry_antonyms_synonyms(*args)
      warn '''
        Client#entry_antonyms_synonyms is DEPRECATED.
        Use Client#thesaurus instead. Reference
        https://github.com/swcraig/oxford-dictionary/pull/14 for more
        information. Check out OxfordDictionary::Endpoints::Thesaurus for the
        interface to use. Specifically use it with
        params: { fields: \'synonyms,antonyms\' }
      '''

      thesaurus(
        word: args.first,
        language: 'en',
        params: { fields: 'antonyms,synonyms' }
      )
    end

    def entry_translations(*args)
      warn '''
        Client#entry_translations is DEPRECATED.
        Use Client#translation instead. Reference
        https://github.com/swcraig/oxford-dictionary/pull/12 for more
        information. Check out OxfordDictionary::Endpoints::Translations for the
        interface to use.
      '''

      language = args[1] && args[1][:translations] || 'es'
      translation(
        word: args.first,
        source_language: 'en-us',
        target_language: language,
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

    def inflection(*args)
      warn '''
          Client#inflection is DEPRECATED.
          Use Client#lemma instead. Reference
          github.com/swcraig/oxford-dictionary/pull/10 for for more information.
          Check out OxfordDictionary::Endpoints::Lemmas#lemma for the interface
          to use.
      '''

      language_parameter = args[1].is_a?(Hash) && args[1][:lang]
      language = language_parameter || 'en'
      args[1].delete(:lang) if language_parameter

      params = args[1]&.map do |key, value|
        if value.is_a?(Array)
          [key, value.join(',')]
        else
          [key, value]
        end
      end.to_h
      parameters = params || {}

      lemma(word: args.first, language: language, params: parameters)
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
