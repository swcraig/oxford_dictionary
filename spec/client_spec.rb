require 'spec_helper'

RSpec.describe OxfordDictionary::Client do
  let(:app_id) { 'ID' }
  let(:app_key) { 'KEY' }

  describe '#new' do
    it 'requires an argument' do
      expect { OxfordDictionary::Client.new(nil) }
        .to raise_error(ArgumentError, 'API id and key required.')
    end

    it 'requires a hash argument' do
      expect { OxfordDictionary::Client.new('string') }
        .to raise_error(ArgumentError, 'API id and key required.')
    end

    it 'requires both id and key' do
      expect { OxfordDictionary.new(app_id: 'ID') }
        .to raise_error(ArgumentError, 'API id and key required.')
    end
  end

  describe '#entry' do
    let(:client) { described_class.new(app_id: app_id, app_key: app_key) }
    subject { client.entry(args) }

    context 'when the argument is a Hash' do
      let(:args) { { word: 'ace', dataset: 'en-us', params: {} } }

      it 'calls the Entries endpoint with correct arguments' do
        expect_any_instance_of(OxfordDictionary::Endpoints::Entries).
          to receive(:entry).
          with(word: args[:word], dataset: args[:dataset], params: args[:params])

        subject
      end
    end
  end
end
