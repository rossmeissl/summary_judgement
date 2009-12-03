module SummaryJudgement
  module InstanceMethods
    def summary(options = {})
      if children
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
        result << children.flatten.map {|c| c.class}.uniq.map do |k|
          siblings = children.flatten.select {|c| c.is_a? k}
          siblings.length.to_s + ' ' + k.to_s.underscore.humanize.downcase.pluralize_on(siblings.length)
        end.to_sentence
      elsif term
        "#{adjectives.join(' ').strip.with_indefinite_article(true)} #{term} #{modifiers.join(' ')}".strip
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
  end
end
