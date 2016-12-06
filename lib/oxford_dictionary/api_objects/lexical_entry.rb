require 'virtus'
require 'oxford_dictionary/api_objects/entry'
require 'oxford_dictionary/api_objects/pronunciation'

# LexicalEntry
class LexicalEntry
  include Virtus.model
  attribute :grammatical_features, Array[OpenStruct]
  attribute :inflection_of, Array[OpenStruct]
  attribute :language, String
  attribute :lexical_category, String
  attribute :text, String
  attribute :entries, Array[Entry]
  attribute :pronunciations, Array[Pronunciation]

  attribute :sentences, Array[OpenStruct]
end
