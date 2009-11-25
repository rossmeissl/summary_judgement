module SummaryJudgement
  module InstanceMethods
    def summary(options = {})
    end
    
    def term
      self.class.summary.class.render self.class.summary.term, self
    end
    
    def adjectives
      self.class.summary.adjectives.select { |a| a.condition.nil? or self.class.summary.class.render(a.condition, self) }.map { |a| self.class.summary.class.render a.phrase, self}
    end
    
    def children
      self.class.summary.class.render self.class.summary.subordinates, self
    end
  end
end
