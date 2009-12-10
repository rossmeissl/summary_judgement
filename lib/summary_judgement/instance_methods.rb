module SummaryJudgement
  module InstanceMethods
    def summary(options = {})
      if children and !children.empty?
        summarize_as_branch(options)
      elsif !self.class.summary.subordinates.empty?
        summarize_as_bare_branch(options)
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
      leaves = canopy
      options[:verbs] ||= :canopy   if leaves.map(&:class).uniq.all? { |k| k.summary.predicate }
      options[:verbs] ||= :branches

      if conjugation = options.delete(:conjugate)
        options.reverse_merge! :plurality => :singular
        case conjugation
        when String
          options[:person] ||= :third
          options[:subject] ||= conjugation
        when Symbol
          options[:person] ||= conjugation
        when TrueClass
          options[:person] ||= :third
        end
        if options[:verbs] == :canopy and options[:subject]
          result << case options[:subject]
          when String
            options[:subject]
          when Symbol, TrueClass
            Verbs::Conjugator.subject(options.slice(:person, :plurality)).humanize
          end
        elsif options[:verbs] == :branches
          result << Verbs::Conjugator.conjugate(self.class.summary.predicate, options.slice(:person, :subject, :tense, :plurality, :aspect)).to_s
          result = result.humanize unless options[:subject]
        end
        result << ' ' if options[:subject]
      end
      
      
      verbosity = options.delete(:verbose)
      verbosity = self.class.summary.class.render verbosity, self
      verbosity = canopy.length <= verbosity if verbosity.is_a? Fixnum
      
      tufts = organize_leaves(*leaves)
      first_tuft = tufts.shift
      connector = verbosity ? ';' : ','
      result << tufts.map { |tuft| summarize_tuft(tuft, conjugation, verbosity, options) }.unshift(summarize_tuft(first_tuft, conjugation, verbosity, options.merge(:capitalize_anonymous => true))).to_sentence(:words_connector => "#{connector} ", :last_word_connector => "#{connector} and ")
    end

    def summarize_as_bare_branch(options = {})
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
      result << self.class.summary.class.render(self.class.summary.default, self).with_indefinite_article
    end
    
    def organize_leaves(*leaves)
      leaves.inject(::ActiveSupport::OrderedHash.new) do |memo, leaf|
        memo[leaf.class] ||= []
        memo[leaf.class] << leaf
        memo
      end
    end
    
    def summarize_tuft(tuft, conjugation, verbosity, options)
      klass, siblings = tuft
      tuft_summary = ''
      if options[:verbs] == :canopy and conjugation
        tuft_summary << Verbs::Conjugator.conjugate(klass.summary.predicate, options.slice(:person, :tense, :aspect, :plurality).reverse_merge(klass.summary.options_for_conjugation)).to_s
        tuft_summary = tuft_summary.humanize unless options[:subject]
        tuft_summary << ' '
      end
      if verbosity
        if conjugation
          tuft_summary << siblings.map { |leaf| leaf.summary :capitalize_indefinite_article => false }.to_sentence
        else
          first_sibling = siblings.shift
          tuft_summary << siblings.map { |leaf| leaf.summary :capitalize_indefinite_article => false }.unshift(first_sibling.summary(:capitalize_indefinite_article => !options[:subject])).to_sentence
        end
      else
        tuft_summary << siblings.length.to_s + ' ' + klass.to_s.underscore.humanize.downcase.pluralize_on(siblings.length)
      end
      tuft_summary
    end

  end
end
