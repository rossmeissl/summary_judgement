module SummaryJudgement
  module InstanceMethods
    def summary(options = {})
    end
    
    def summary_term
      return unless self.class.summary
      self.class.summary.class.render self.class.summary.term
    end
  end
end
