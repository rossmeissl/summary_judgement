require 'helper'

class TestSummaryJudgement < Test::Unit::TestCase
  def setup
    @neuromancer = Book.new :book_type => 'novel', :author => 'William Gibson'
    @where_the_wild_things_are = Book.new :book_type => 'childrens book', :author => 'Maurice Sendak', :pictures => true
    @bookshelf = Library.new @neuromancer, @where_the_wild_things_are
  end
end
