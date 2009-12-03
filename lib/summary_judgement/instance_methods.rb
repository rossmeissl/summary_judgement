module SummaryJudgement
  module InstanceMethods
    def summary(options = {})
      if children
        summarize_as_branch(options)
      elsif term
        summarize_as_leaf
      end
    end
    
    def term
      self.class.summary.class.render self.class.summary.term, self
    end
    
    def adjectives
      self.class.summary.adjectives.select { |a| a.condition.nil? or self.class.summary.class.render(a.condition, self) }.map { |a| self.class.summary.class.render a.phrase, self}
    end
    
    def modifiers
      self.class.summary.modifiers.select { |m| m.condition.nil? or self.class.summary.class.render(m.condition, self) }.map { |m| self.class.summary.class.render m.phrase, self}
    end
    
    def children
      self.class.summary.class.render self.class.summary.subordinates, self
    end
    
    def canopy
      branches, leaves = children.flatten.partition(&:children)
      (leaves + branches.collect(&:canopy)).flatten.uniq
    end
    
    private
    
    def summarize_as_leaf
      "#{adjectives.join(' ').strip.with_indefinite_article(true)} #{term} #{modifiers.join(' ')}".strip
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
      result << canopy.map {|c| c.class}.uniq.map do |k|
        siblings = canopy.select {|c| c.is_a? k}
        siblings.length.to_s + ' ' + k.to_s.underscore.humanize.downcase.pluralize_on(siblings.length)
      end.to_sentence
    end
  end
end
