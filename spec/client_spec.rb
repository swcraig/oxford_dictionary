require 'spec_helper'

describe 'Client' do
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
end
