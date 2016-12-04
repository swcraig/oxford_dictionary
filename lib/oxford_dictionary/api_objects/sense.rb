require 'virtus'

# Sense
class Sense
  include Virtus.model
  attribute :id, String
  attribute :definitions, Array[String]
  attribute :examples, Array[OpenStruct]
  attribute :registers, Array[String]

  attribute :antonyms, Array[OpenStruct]
  attribute :synonyms, Array[OpenStruct]

  attribute :translations, Array[OpenStruct]
end
