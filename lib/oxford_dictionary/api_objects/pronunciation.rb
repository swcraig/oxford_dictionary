require 'virtus'

# Pronunciation
class Pronunciation
  include Virtus.model
  attribute :audio_file, String
  attribute :dialects, Array[String]
  attribute :phonetic_notation, String
  attribute :phonetic_spelling, String
end
