require 'virtus'

# Sense
class Sense
  include Virtus.model
  attribute :id, String
  attribute :antonyms, Array[OpenStruct]
  attribute :cross_references, Array[OpenStruct]
  attribute :cross_reference_markers, Array[String]
  attribute :definitions, Array[String]
  attribute :domains, Array[String]
  attribute :examples, Array[OpenStruct]
  attribute :regions, Array[String]
  attribute :registers, Array[String]
  attribute :subsenses, Array[Sense]
  attribute :synonyms, Array[OpenStruct]
  attribute :translations, Array[OpenStruct]
  attribute :variant_forms, Array[OpenStruct]
end
