require 'spec_helper'
require 'oxford_dictionary/endpoints/entries'

# Spec dependencies
require 'oxford_dictionary/request'

RSpec.describe OxfordDictionary::Endpoints::Entries do
  let(:request_client) do
    OxfordDictionary::Request.
      new(app_id: ENV['APP_ID'], app_key: ENV['APP_KEY'])
  end

  let(:endpoint) { described_class.new(request_client: request_client) }

  let(:word) { 'ace' }
  let(:params) { {} }
  let(:dataset) { 'en-gb' }

  describe '#entry' do
    subject { endpoint.entry(word: word, dataset: dataset, params: params) }

    it 'calls API as expected', :aggregate_failures do
      expect(request_client).to receive(:get).
        with(uri: URI('entries/en-gb/ace')).and_call_original

      VCR.use_cassette('entries#entry') do
        response = subject
        expect(response).to be_an(OpenStruct)
        expect(response.id).to eq(word)
        expect(response.results.first.lexicalEntries).to all(be_an(OpenStruct))
      end
    end

    context 'when the params include lexicalCategory: verb' do
      let(:params) { { lexicalCategory: 'verb' } }

      it 'only returns entries that are verbs', :aggregate_failures do
        expect(request_client).to receive(:get).
          with(uri: URI('entries/en-gb/ace?lexicalCategory=verb')).
          and_call_original

        VCR.use_cassette('entries#entry-verbs') do
          response = subject

          lexical_entries = response.results.first.lexicalEntries
          lexical_categories =
            lexical_entries.map { |entry| entry.lexicalCategory.id }.uniq

          expect(response).to be_an(OpenStruct)
          expect(response.id).to eq(word)
          expect(response.results.first.lexicalEntries).
            to all(be_an(OpenStruct))
          expect(lexical_categories.length).to eq(1)
        end
      end
    end

    context 'when the dataset is en-us' do
      let(:dataset) { 'en-us' }

      it 'calls the API with en-us in the URL' do
        expect(request_client).to receive(:get).
          with(uri: URI('entries/en-us/ace')).
          and_call_original

        VCR.use_cassette('entries#entry-en-us') do
          response = subject
          expect(response).to be_an(OpenStruct)
          expect(response.id).to eq(word)
          expect(response.results.first.lexicalEntries).
            to all(be_an(OpenStruct))
          expect(response.results.first.language).to eq('en-us')
        end
      end
    end
  end
end
