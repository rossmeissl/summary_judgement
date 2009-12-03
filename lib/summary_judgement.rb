require 'active_support'
require 'verbs'

module SummaryJudgement
  def self.extended(base)
    base.initialize_summary Summary.new(base)
    def base.inherited(subclass)
      subclass.initialize_summary @summary.dup(subclass)
    end
  end
  
  def summarize(&blk)
    @summary ||= Summary.new(self)
    @summary.define(&blk)
    send :include, InstanceMethods
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