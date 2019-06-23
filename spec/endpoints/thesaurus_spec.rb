require 'spec_helper'
require 'oxford_dictionary/endpoints/thesaurus'

# Spec dependencies
require 'oxford_dictionary/request'

RSpec.describe OxfordDictionary::Endpoints::Thesaurus do
  let(:request_client) do
    OxfordDictionary::Request.
      new(app_id: ENV['APP_ID'], app_key: ENV['APP_KEY'])
  end

  let(:endpoint) { described_class.new(request_client: request_client) }

  let(:word) { 'ace' }
  let(:language) { 'en' }
  let(:params) { { fields: 'synonyms,antonyms' } }

  # The thesaurus endpoint is only avaiable to the paid tier
  # If someone with a paid tier account would like to contribute, please
  # feel free remove this double (and the stub in the tests), uncomment the
  # sections that run VCR against the live endpoint, and PR the resulting files
  let(:response_double) { double(body: {}.to_json) }

  describe '#thesaurus' do
    subject do
      endpoint.thesaurus(word: word, language: language, params: params)
    end

    it 'calls API as expected', :aggregate_failures do
      expected_uri =
        URI("thesaurus/#{language}/#{word}?fields=synonyms%2Cantonyms")

      expect(request_client).to receive(:get).
        with(uri: expected_uri).
        and_return(response_double)

      subject

      # VCR.use_cassette('thesaurus#thesaurus') do
      #   response = subject
      #   expect(response).to be_an(OpenStruct)
      #   expect(response.results.first.id).to eq(word)
      #   expect(response.results.first.lexicalEntries).to all(be_an(OpenStruct))
      # end
    end
  end
end
