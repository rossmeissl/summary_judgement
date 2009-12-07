module SummaryJudgement
  module InstanceMethods
    def summary(options = {})
      if children
        summarize_as_branch(options)
      elsif term
        summarize_as_leaf(options)
      end
    end
    
    def term
      self.class.summary.class.render self.class.summary.terms.find { |t| t.condition.nil? or self.class.summary.class.render(t.condition, self) }.phrase, self
    end
    
    def adjectives
      self.class.summary.adjectives.select { |a| a.condition.nil? or self.class.summary.class.render(a.condition, self) }.map { |a| self.class.summary.class.render a.phrase, self}
    end
    
    def modifiers
      self.class.summary.modifiers.select { |m| m.condition.nil? or self.class.summary.class.render(m.condition, self) }.map { |m| self.class.summary.class.render m.phrase, self}
    end
    
    def children
      subordinates = self.class.summary.class.render(self.class.summary.subordinates, self)
      subordinates.flatten! if subordinates.respond_to? :flatten!
      subordinates
    end
    
    def canopy
      branches, leaves = children.flatten.partition(&:children)
      (leaves + branches.collect(&:canopy)).flatten.uniq
    end
    
    private
    
    def summarize_as_leaf(options = {})
      options.reverse_merge! :capitalize_indefinite_article => true
      "#{adjectives.join(' ').strip.concat(' ').concat(term).strip.with_indefinite_article(options[:capitalize_indefinite_article])} #{modifiers.join(' ')}".strip
    end
    
    def summarize_as_branch(options = {})
      result = ''
      if conjugation = options.delete(:conjugate)
        options.reverse_merge! :tense => :present, :plurality => :singular
        case conjugation
        when String
          options[:person] ||= :third
          options[:subject] ||= conjugation
        when Symbol
          options[:person] ||= conjugation
        when TrueClass
          options[:person] ||= :third
        end
        result << Verbs::Conjugator.conjugate(self.class.summary.predicate, options.slice(:person, :subject, :tense, :plurality)).to_s.humanize
        result << ' '
      end
      
      verbosity = options.delete(:verbose)
      verbosity = self.class.summary.class.render verbosity, self
      verbosity = canopy.length <= verbosity if verbosity.is_a? Fixnum
      
      if verbosity
        leaves = canopy
        first_leaf = leaves.shift
        result << leaves.map { |leaf| leaf.summary :capitalize_indefinite_article => false }.unshift(first_leaf.summary(:capitalize_indefinite_article => !conjugation)).to_sentence
      else
        result << canopy.map {|c| c.class}.uniq.map do |k|
          siblings = canopy.select {|c| c.is_a? k}
          siblings.length.to_s + ' ' + k.to_s.underscore.humanize.downcase.pluralize_on(siblings.length)
        end.to_sentence
      end
    end
  end
end
