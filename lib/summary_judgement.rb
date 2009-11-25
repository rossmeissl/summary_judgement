module SummaryJudgement
  def summarize(&blk)
    raise 'You can only summarize a class once' if @@summary
    cattr_reader :summary
    @@summary = yield Summary.new
    send :include, InstanceMethods
  end
end

require 'summary_judgement/summary'
require 'summary_judgement/instance_methods'