require 'spec_helper'
require 'oxford_dictionary/endpoints/search'

# Spec dependencies
require 'oxford_dictionary/request'

RSpec.describe OxfordDictionary::Endpoints::Search do
  let(:request_client) do
    OxfordDictionary::Request.
      new(app_id: ENV['APP_ID'], app_key: ENV['APP_KEY'])
  end

  let(:endpoint) { described_class.new(request_client: request_client) }

  # The search endpoint is only avaiable to the paid tier
  # If someone with a paid tier account would like to contribute, please
  # feel free remove this double (and the stub in the tests), uncomment the
  # sections that run VCR against the live endpoint, and PR the resulting files
  let(:response_double) { double(body: {}.to_json) }

  describe '#search' do
    subject do
      endpoint.search(language: language, params: params)
    end

    let(:language) { 'en-gb' }
    let(:params) { { q: 'an' } }

    it 'calls API as expected', :aggregate_failures do
      expected_uri = URI("search/#{language}?q=an")

      expect(request_client).to receive(:get).
        with(uri: expected_uri).
        and_return(response_double)

      subject

      # VCR.use_cassette('search#search') do
      #   response = subject
      #   expect(response).to be_an(OpenStruct)
      #   expect(response.results.first.id).to eq(word)
      #   expect(response.results.first.lexicalEntries).
      #     to all(be_an(OpenStruct))
      # end
    end
  end

  describe '#search_translation' do
    subject do
      endpoint.search_translation(
        source_language: source_language,
        target_language: target_language,
        params: params
      )
    end

    let(:source_language) { 'en' }
    let(:target_language) { 'es' }
    let(:params) { { q: 'an' } }

    it 'calls API as expected', :aggregate_failures do
      expected_uri =
        URI("search/translations/#{source_language}/#{target_language}?q=an")

      expect(request_client).to receive(:get).
        with(uri: expected_uri).
        and_return(response_double)

      subject

      # VCR.use_cassette('search#search_translation') do
      #   response = subject
      #   expect(response).to be_an(OpenStruct)
      #   expect(response.results.first.id).to eq(word)
      #   expect(response.results.first.lexicalEntries).
      #     to all(be_an(OpenStruct))
      # end
    end
  end
end
