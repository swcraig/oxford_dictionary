module OxfordDictionary
  # Basic class for errors
  class Error < StandardError
    attr_reader :code

    def initialize(response)
      @code = response.code
    end
  end
end
