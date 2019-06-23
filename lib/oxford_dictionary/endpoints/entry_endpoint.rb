require 'oxford_dictionary/deprecated_request'
require 'oxford_dictionary/api_objects/entry_response'

module OxfordDictionary
  module Endpoints
    # Interface to '/entries' endpoint
    module EntryEndpoint
      include OxfordDictionary::DeprecatedRequest
      ENDPOINT = 'entries'.freeze

      def entry(query, params = {})
        entry_request(query, params)
      end

      def entry_definitions(query, params = {})
        warn '''
        Client#entry_defintions is DEPRECATED and will become non-functional
        on June 30, 2019. Use Client#entry instead. Reference
        https://github.com/swcraig/oxford-dictionary/pull/8 for more
        information. Check out OxfordDictionary::Endpoints::Entries for the
        interface to use. Specifically use it with
        params: { fields: \'definitions\' }
        '''

        params[:end] = 'definitions'
        entry_request(query, params)
      end

      def entry_examples(query, params = {})
        warn '''
        Client#entry_examples is DEPRECATED and will become non-functional
        on June 30, 2019. Use Client#entry instead. Reference
        https://github.com/swcraig/oxford-dictionary/pull/8 for more
        information. Check out OxfordDictionary::Endpoints::Entries for the
        interface to use. Specifically use it with
        params: { fields: \'examples\' }
        '''

        params[:end] = 'examples'
        entry_request(query, params)
      end

      def entry_pronunciations(query, params = {})
        warn '''
        Client#entry_pronunciations is DEPRECATED and will become non-functional
        on June 30, 2019. Use Client#entry instead. Reference
        https://github.com/swcraig/oxford-dictionary/pull/8 for more
        information. Check out OxfordDictionary::Endpoints::Entries for the
        interface to use. Specifically use it with
        params: { fields: \'pronunciations\' }
        '''

        params[:end] = 'pronunciations'
        entry_request(query, params)
      end

      def entry_sentences(query, params = {})
        warn '''
        Client#entry_sentences is DEPRECATED and will become non-functional
        on June 30, 2019. Use Client#sentence instead. Reference
        https://github.com/swcraig/oxford-dictionary/pull/13 for more
        information. Check out OxfordDictionary::Endpoints::Sentences for the
        interface to use.
        '''

        params[:end] = 'sentences'
        entry_request(query, params)
      end

      def entry_antonyms(query, params = {})
        warn '''
        Client#entry_antonyms is DEPRECATED and will become non-functional
        on June 30, 2019. Use Client#thesaurus instead. Reference
        https://github.com/swcraig/oxford-dictionary/pull/13 for more
        information. Check out OxfordDictionary::Endpoints::Thesaurus for the
        interface to use. Specifically use it with
        params: { fields: \'antonyms\' }
        '''

        params[:end] = 'antonyms'
        entry_request(query, params)
      end

      def entry_synonyms(query, params = {})
        warn '''
        Client#entry_synonyms is DEPRECATED and will become non-functional
        on June 30, 2019. Use Client#thesaurus instead. Reference
        https://github.com/swcraig/oxford-dictionary/pull/13 for more
        information. Check out OxfordDictionary::Endpoints::Thesaurus for the
        interface to use. Specifically use it with
        params: { fields: \'synonyms\' }
        '''

        params[:end] = 'synonyms'
        entry_request(query, params)
      end

      def entry_antonyms_synonyms(query, params = {})
        warn '''
        Client#entry_antonyms_synonyms is DEPRECATED and will be non-functional
        on June 30, 2019. Use Client#thesaurus instead. Reference
        https://github.com/swcraig/oxford-dictionary/pull/14 for more
        information. Check out OxfordDictionary::Endpoints::Thesaurus for the
        interface to use. Specifically use it with
        params: { fields: \'synonyms,antonyms\' }
        '''

        params[:end] = 'synonyms;antonyms'
        entry_request(query, params)
      end

      def entry_translations(query, params = {})
        warn '''
        Client#entry_translations is DEPRECATED and will become non-functional
        on June 30, 2019. Use Client#translation instead. Reference
        https://github.com/swcraig/oxford-dictionary/pull/12 for more
        information. Check out OxfordDictionary::Endpoints::Translations for the
        interface to use.
        '''
        params.key?(:translations) || params[:translations] = 'es'
        entry_request(query, params)
      end

      private

      def entry_request(query, params)
        EntryResponse.new(request(ENDPOINT, query, params)['results'][0])
      end
    end
  end
end
