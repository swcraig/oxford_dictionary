require 'spec_helper'
require 'oxford_dictionary/deserialize'

RSpec.describe OxfordDictionary::Deserialize do
  let(:payload) { { someKey: 'some-value' }.to_json }

  describe '#call' do
    subject { described_class.new.call(payload) }
    let(:expected_struct) { OpenStruct.new(someKey: 'some-value') }

    it 'parses the JSON into an OpenStruct' do
      expect(subject).to eq(expected_struct)
    end
  end
end
