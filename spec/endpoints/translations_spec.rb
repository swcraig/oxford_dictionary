require 'spec_helper'
require 'oxford_dictionary/endpoints/translations'

# Spec dependencies
require 'oxford_dictionary/request'

RSpec.describe OxfordDictionary::Endpoints::Translations do
  let(:request_client) do
    OxfordDictionary::Request.
      new(app_id: ENV['APP_ID'], app_key: ENV['APP_KEY'])
  end

  let(:endpoint) { described_class.new(request_client: request_client) }

  let(:word) { 'ace' }
  let(:source_language) { 'en' }
  let(:target_language) { 'es' }
  let(:params) { {} }

  # The translations endpoint is only avaiable to the paid tier
  # If someone with a paid tier account would like to contribute, please
  # feel free remove this double (and the stub in the tests), uncomment the
  # sections that run VCR against the live endpoint, and PR the resulting files
  let(:response_double) { double(body: {}.to_json) }

  describe '#translation' do
    subject do
      endpoint.translation(
        word: word,
        source_language: source_language,
        target_language: target_language,
        params: params
      )
    end

    it 'calls API as expected', :aggregate_failures do
      expected_uri =
        URI("translations/#{source_language}/#{target_language}/#{word}")

      expect(request_client).to receive(:get).
        with(uri: expected_uri).
        and_return(response_double)

      subject

      # VCR.use_cassette('translations#translation') do
      #   response = subject
      #   expect(response).to be_an(OpenStruct)
      #   expect(response.results.first.id).to eq(word)
      #   expect(response.results.first.lexicalEntries).to all(be_an(OpenStruct))
      # end
    end

    context 'when the params include strictMatch: true' do
      let(:params) { { strictMatch: true } }

      it 'only returns strict match translations', :aggregate_failures do
        expected_uri =
          URI("translations/#{source_language}/#{target_language}/#{word}?strictMatch=true")

        expect(request_client).to receive(:get).
          with(uri: expected_uri).
          and_return(response_double)

        subject

        # VCR.use_cassette('translations#translation-strict') do
        #   response = subject
        #   expect(response).to be_an(OpenStruct)
        #   expect(response.results.first.id).to eq(word)
        # end
      end
    end
  end
end
