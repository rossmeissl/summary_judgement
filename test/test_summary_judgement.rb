require 'helper'

class TestSummaryJudgement < Test::Unit::TestCase
  def setup
    @neuromancer = Book.new :book_type => 'novel', :author => 'William Gibson'
    @where_the_wild_things_are = Book.new :book_type => 'childrens book', :author => 'Maurice Sendak', :pictures => true
    @current_economist = Magazine.new :year => 2009, :month => "December"
    @bookshelf = Library.new @neuromancer, @where_the_wild_things_are
    @toilet = Library.new @neuromancer, @current_economist
    @catalog = Catalog.new @bookshelf, @toilet
  end
  
  def test_setup
    assert_equal Book, @neuromancer.class
    assert_equal Library, @bookshelf.class
    assert_equal 2, @bookshelf.books.length
    assert_equal :accept, Verbs::Conjugator.conjugate(:accept, :tense => :present, :person => :first, :plurality => :singular) 
  end
  
  def test_summary_definition
    assert_equal SummaryJudgement::Summary, Book.summary.class
    assert_equal Proc, Book.summary.term.class
    assert_equal [SummaryJudgement::Descriptor], Book.summary.adjectives.collect { |a| a.class }.uniq
    assert_equal :have, Library.summary.predicate
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
    assert_equal '1 book and 1 magazine', @toilet.summary
    assert_equal '2 libraries', @catalog.summary
  end
  
  def test_conjugated_summary
    assert_equal 'Has 2 books', @bookshelf.summary(:conjugate => true, :subject => false)
    assert_equal 'You have 2 books', @bookshelf.summary(:conjugate => :second, :subject => true)
  end
  
end
