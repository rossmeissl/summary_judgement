module SummaryJudgement
  class Summary
    attr_reader :terms, :adjectives, :modifiers, :subordinates, :base
    
    def initialize(base, options = {}, &blk)
      @base = base
      @terms = options[:terms] || []
      @adjectives = options[:adjectives] || []
      @modifiers = options[:modifiers] || []
      @subordinates = options[:subordinates] || []
      @verb = options[:verb]
      @aspect = options[:aspect]
      @tense = options[:tense]
      @placeholder = options[:placeholder]
    end
    
    def define(&blk)
      yield self
    end
    
    def identity(t = nil, options = {})
      @terms << SummaryJudgement::Descriptor.new(t || @base.to_s.underscore.humanize.downcase, options)
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
    
    def tense(t)
      @tense = t
    end
    
    def aspect(a)
      @aspect = a
    end
    
    def options_for_conjugation
      { :tense => @tense, :aspect => @aspect }
    end
    
    def placeholder(p)
      @placeholder = p
    end
    
    def default
      @placeholder
    end
    
    def to_hash
      [:adjectives, :modifiers, :subordinates, :terms, :verb, :placeholder, :aspect, :tense].inject({}) do |properties, property|
        val = instance_variable_get :"@#{property}"
        case val
        when Symbol, NilClass, TrueClass, FalseClass, Fixnum
          properties[property] = val
        else
          properties[property] = val.clone
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
        when TrueClass, FalseClass, NilClass, String, Fixnum
          obj
        when Array
          if obj.empty?
            nil
          elsif obj.all? { |e| e.is_a? Symbol }
            context.recursive_send(*obj)
          else
            obj.empty? ? nil : obj.map {|o| render o, context}
          end
        when Symbol
          context.send obj
        when Proc
          obj.call context
        end
      end
    end
  end
end
