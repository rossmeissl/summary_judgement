require 'helper'

class TestSummaryJudgement < Test::Unit::TestCase
  def setup
    @neuromancer = Book.new :book_type => 'novel', :author => 'William Gibson'
    #@first_edition_neuromancer = Hardcover.new :book_type => 'novel', :author => 'William Gibson'
    @where_the_wild_things_are = Book.new :book_type => 'childrens book', :author => 'Maurice Sendak', :pictures => true
    @current_economist = Magazine.new :year => 2009, :month => "December"
    @bookshelf = Library.new @neuromancer, @where_the_wild_things_are
    @toilet = Library.new @neuromancer, @current_economist
    @bedstand = Library.new @neuromancer
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
  
  def test_foliage
    assert_equal 3, @catalog.canopy.length
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
    assert_equal '2 books and 1 magazine', @catalog.summary
    assert_equal 'A novel by William Gibson', @neuromancer.summary
  end
  
  def test_conjugated_summary
    assert_equal 'Has 2 books', @bookshelf.summary(:conjugate => true, :subject => false)
    assert_equal 'You have 2 books', @bookshelf.summary(:conjugate => :second, :subject => true)
    assert_equal 'The catalog contains 2 books and 1 magazine', @catalog.summary(:conjugate => :third, :subject => 'The catalog')
  end
  
  def test_verbose_summaries
    assert_equal 'A novel by William Gibson and an illustrated childrens book by Maurice Sendak', @bookshelf.summary(:verbose => true)
  end
  
  def test_conjugated_verbose_summaries
    assert_equal 'I have a novel by William Gibson and an illustrated childrens book by Maurice Sendak', @bookshelf.summary(:verbose => true, :conjugate => :first, :subject => true)
  end
  
  def test_summaries_with_adaptive_verbosity
    assert_equal '2 books', @bookshelf.summary(:verbose => :small?)
    assert_equal 'A novel by William Gibson', @bedstand.summary(:verbose => :small?)
  end
  
  def test_conjugated_summaries_with_adaptive_verbosity
    assert_equal 'They have 2 books', @bookshelf.summary(:verbose => :small?, :conjugate => :third, :plurality => :plural, :subject => true)
    assert_equal 'They have a novel by William Gibson', @bedstand.summary(:verbose => :small?, :conjugate => :third, :plurality => :plural, :subject => true)
  end
  
#  def test_inheritance
#    assert_equal 'A hardcover novel by William Gibson', @first_edition_neuromancer.summary
#  end  
end
