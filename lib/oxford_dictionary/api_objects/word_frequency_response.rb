# frozen_string_literal: true

require 'virtus'

class WordFrequencyResponse
  class Metadata
    class Options
      include Virtus.model
      attribute :corpus, String
      attribute :lemma, String
    end

    include Virtus.model
    attribute :language, String
    attribute :options, WordFrequencyResponse::Metadata::Options
  end

  class Result
    include Virtus.model
    attribute :frequency, Integer
    attribute :lemma, String
    attribute :match_count, Integer
    attribute :normalized_frequency, Float
  end

  include Virtus.model
  attribute :metadata, WordFrequencyResponse::Metadata
  attribute :result, WordFrequencyResponse::Result
end
