module OxfordDictionary
  # Basic class for errors
  class Error < StandardError
    attr_reader :code

    def initialize(code)
      @code = code
    end
  end
end
