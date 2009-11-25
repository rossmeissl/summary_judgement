module SummaryJudgement
  class Descriptor
    attr_reader :phrase
    
    def initialize(phrase, options = {})
      @phrase = phrase
      @condition = options[:if]
    end
  end
end
