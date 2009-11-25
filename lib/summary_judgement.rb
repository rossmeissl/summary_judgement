require 'active_support/core_ext'

module SummaryJudgement
  def summarize(&blk)
    cattr_accessor :summary
    self.summary = Summary.new(self, &blk)
    send :include, InstanceMethods
  end
end

require 'summary_judgement/summary'
require 'summary_judgement/descriptor'
require 'summary_judgement/instance_methods'