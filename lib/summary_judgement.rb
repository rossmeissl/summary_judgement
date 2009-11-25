module SummaryJudgement
  def summarize(&blk)
    #raise 'You can only summarize a class once' if defined? @@summary
    @@summary = yield Summary.new(self)
    send :include, InstanceMethods
  end
  
  def summary
    @@summary
  end
end

require 'summary_judgement/summary'
require 'summary_judgement/descriptor'
require 'summary_judgement/instance_methods'