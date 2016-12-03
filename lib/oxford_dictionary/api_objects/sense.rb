require 'virtus'

# Sense
class Sense
  include Virtus.model
  attribute :id, String
  attribute :definitions, Array[String]
  attribute :examples, Array[Hash]
  attribute :registers, Array[String]
end
