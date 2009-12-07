require 'active_support'
require 'verbs'

module SummaryJudgement
  def self.extended(base)
    base.initialize_summary Summary.new(base)
    base.send :include, InstanceMethods
    def base.inherited(subclass)
      subclass.initialize_summary @summary.dup(subclass)
      super
    end
  end
  
  def summarize(&blk)
    @summary.define(&blk)
  end
  
  def summary
    @summary
  end
  
  def initialize_summary(summary)
    @summary = summary
  end
end

require 'summary_judgement/summary'
require 'summary_judgement/descriptor'
require 'summary_judgement/instance_methods'
require 'summary_judgement/core_extensions'