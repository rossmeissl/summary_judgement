module SummaryJudgement
  class Summary
    attr_reader :term, :adjectives, :modifiers, :subordinates, :base
    
    def initialize(base, options = {}, &blk)
      @base = base
      @term = options[:term] || base.to_s
      @adjectives = options[:adjectives] || []
      @modifiers = options[:modifiers] || []
      @subordinates = options[:subordinates] || []
    end
    
    def define(&blk)
      yield self
    end
    
    def identity(t)
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
        @subordinates << lambda { |parent| parent.send collection_or_symbol }
      else
        @subordinates << collection_or_symbol
      end
    end
    
    def verb(infinitive)
      @verb = infinitive
    end
    
    def predicate
      @verb
    end
    
    def to_hash
      { :adjectives => @adjectives.dup, :modifiers => @modifiers.dup, :subordinates => @subordinates.dup, :term => @term.dup }
    end
    
    def dup(base)
      self.class.new base, to_hash
    end
    
    class << self
      def render(obj, context)
        case obj
        when Array
          obj.empty? ? nil : obj.map {|o| render o, context}
        when String
          obj
        when Symbol
          context.send obj
        when Proc
          obj.call context
        end
      end
    end
  end
end
