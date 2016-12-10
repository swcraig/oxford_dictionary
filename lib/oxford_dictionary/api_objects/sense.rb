require 'virtus'

# Sense
class Sense
  include Virtus.model
  attribute :id, String
  attribute :cross_reference_markers, Array[String]
  attribute :cross_references, Array[OpenStruct]

  attribute :definitions, Array[String]
  attribute :examples, Array[OpenStruct]
  attribute :registers, Array[String]

  attribute :subsenses, Array[Sense]

  attribute :antonyms, Array[OpenStruct]
  attribute :synonyms, Array[OpenStruct]

  attribute :translations, Array[OpenStruct]
end
