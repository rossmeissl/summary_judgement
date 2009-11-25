require 'active_support/core_ext'

module SummaryJudgement
  def summarize(&blk)
    @summary = Summary.new(self, &blk)
    send :include, InstanceMethods
  end
  
  def summary
    @summary
  end
end

require 'summary_judgement/summary'
require 'summary_judgement/descriptor'
require 'summary_judgement/instance_methods'