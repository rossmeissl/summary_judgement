require 'helper'

class TestSummaryJudgement < Test::Unit::TestCase
  def setup
    @neuromancer = Book.new :book_type => 'novel', :author => 'William Gibson'
    @where_the_wild_things_are = Book.new :book_type => 'childrens book', :author => 'Maurice Sendak', :pictures => true
    @bookshelf = Library.new @neuromancer, @where_the_wild_things_are
    @toilet = Library.new @neuromancer
    @catalog = Catalog.new @bookshelf, @toilet
  end
  
  def test_setup
    assert_equal Book, @neuromancer.class
    assert_equal Library, @bookshelf.class
    assert_equal 2, @bookshelf.books.length
  end
  
  def test_summary_definition
    assert_equal SummaryJudgement::Summary, Book.summary.class
    assert_equal Proc, Book.summary.term.class
    assert_equal [SummaryJudgement::Descriptor], Book.summary.adjectives.collect { |a| a.class }.uniq
  end
  
  def test_leaf_summary_rendering
    assert_equal 'novel', @neuromancer.term
    assert @where_the_wild_things_are.adjectives.include?('illustrated')
  end
  
  def test_association
    assert_equal 2, @bookshelf.children.length
  end
  
  def test_summary
    assert_equal 'An illustrated childrens book by Maurice Sendak', @where_the_wild_things_are.summary
    assert_equal '2 books', @bookshelf.summary
    assert_equal '1 book', @toilet.summary
    assert_equal '2 libraries', @catalog.summary
  end
  
end
