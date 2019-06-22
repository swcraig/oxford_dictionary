require 'spec_helper'
require 'oxford_dictionary/endpoints/lemmas'

# Spec dependencies
require 'oxford_dictionary/request'

RSpec.describe OxfordDictionary::Endpoints::Lemmas do
  let(:request_client) do
    OxfordDictionary::Request.
      new(app_id: ENV['APP_ID'], app_key: ENV['APP_KEY'])
  end

  let(:endpoint) { described_class.new(request_client: request_client) }

  let(:word) { 'ace' }
  let(:language) { 'en' }
  let(:params) { {} }

  describe '#lemma' do
    subject { endpoint.lemma(word: word, language: language, params: params) }

    it 'calls API as expected', :aggregate_failures do
      expect(request_client).to receive(:get).
        with(uri: URI("lemmas/#{language}/#{word}")).and_call_original

      VCR.use_cassette('lemmas#lemma') do
        response = subject
        expect(response).to be_an(OpenStruct)
        expect(response.results.first.id).to eq(word)
        expect(response.results.first.lexicalEntries).to all(be_an(OpenStruct))
      end
    end

    context 'when the params include lexicalCategory: verb' do
      let(:params) { { lexicalCategory: 'verb' } }

      it 'only returns lemmas that are verbs', :aggregate_failures do
        expect(request_client).to receive(:get).
          with(uri: URI("lemmas/#{language}/#{word}?lexicalCategory=verb")).
          and_call_original

        VCR.use_cassette('lemmas#lemma-verbs') do
          response = subject

          lexical_entries = response.results.first.lexicalEntries
          lexical_categories =
            lexical_entries.map { |entry| entry.lexicalCategory.id }.uniq

          expect(response).to be_an(OpenStruct)
          expect(response.results.first.id).to eq(word)
          expect(response.results.first.lexicalEntries).
            to all(be_an(OpenStruct))
          expect(lexical_categories.length).to eq(1)
        end
      end
    end

    context "when the language is es" do
      let(:word) { 'fuego' }
      let(:language) { 'es' }

      it 'calls the API with en-us in the URL', :aggregate_failures do
        expect(request_client).to receive(:get).
          with(uri: URI("lemmas/#{language}/#{word}")).
          and_call_original

        VCR.use_cassette('lemmas#lemma-es') do
          response = subject
          expect(response).to be_an(OpenStruct)
          expect(response.results.first.id).to eq(word)
          expect(response.results.first.lexicalEntries).
            to all(be_an(OpenStruct))
          expect(response.results.first.language).to eq(language)
        end
      end
    end
  end
end
