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
    
    def children(*collections_or_symbols)
      collections_or_symbols.each do |collection_or_symbol|
        case collection_or_symbol
        when Symbol
          @subordinates << lambda { |parent| parent.send collection_or_symbol }
        else
          @subordinates << collection_or_symbol
        end
      end
    end
    
    def verb(infinitive)
      @verb = infinitive
    end
    
    def predicate
      @verb
    end
    
    def to_hash
      [:adjectives, :modifiers, :subordinates, :term].inject({}) do |properties, property|
        val = instance_variable_get :"@#{property}"
        case val
        when Symbol
          properties[property] = val
        else
          properties[property] = val.dup
        end
        properties
      end
    end
    
    def dup(base)
      self.class.new base, to_hash
    end
    
    class << self
      def render(obj, context)
        case obj
        when Array
          if obj.empty?
            nil
          elsif obj.all? { |e| e.is_a? Symbol }
            context.recursive_send(*obj)
          else
            obj.empty? ? nil : obj.map {|o| render o, context}
          end
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
