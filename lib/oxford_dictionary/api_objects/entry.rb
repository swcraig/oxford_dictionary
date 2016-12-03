require 'virtus'
require 'oxford_dictionary/api_objects/sense'

# Entry
class Entry
  include Virtus.model
  attribute :grammatical_features, Array[Hash]
  attribute :etymologies, Array[String]
  attribute :homograph_number, String
  attribute :senses, Array[Sense]
end
