require 'helper'

class TestSummaryJudgement < Test::Unit::TestCase
  def setup
    @neuromancer = Book.new :book_type => 'novel', :author => 'William Gibson'
    @where_the_wild_things_are = Book.new :book_type => 'childrens book', :author => 'Maurice Sendak', :pictures => true
    @bookshelf = Library.new @neuromancer, @where_the_wild_things_are
  end
  
  def test_setup
    assert_equal Book, @neuromancer.class
    assert_equal Library, @bookshelf.class
    assert_equal 2, @bookshelf.books.length
  end
  
  def test_summary_definition
    assert_equal SummaryJudgement::Summary, Book.summary.class
    assert_equal Proc, Book.summary.term.class
  end
end
