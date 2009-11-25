module SummaryJudgement
  class Summary
    attr_reader :term
    
    def initialize(base)
      @base = base
      @term = base.to_s
      @adjectives = []
      @modifiers = []
      @children = []
    end
    
    def term(t)
      @term = t
    end
    
    def adjective(a, options = {})
      @adjectives << SummaryJudgement::Descriptor.new(a, options)
    end
    
    def modifier(m, options = {})
      @modifiers << SummaryJudgement::Descriptor.new(m, options)
    end
    
    def children(collection_or_symbol)
      case collection_or_symbol
      when Symbol
        lambda { send :collection_or_symbol }
      else
        @children = collection_or_symbol
      end
    end
    
    class << self
      def render(obj)
        case obj
        when String
          obj
        when Symbol
          send obj
        when Proc
          obj.call
        end
      end
    end
  end
end
