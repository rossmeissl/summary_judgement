require 'helper'

class TestSummaryJudgement < Test::Unit::TestCase
  def setup
    @neuromancer = Book.new :book_type => 'novel', :author => 'William Gibson'
    @first_edition_neuromancer = Hardcover.new :book_type => 'novel', :author => 'William Gibson'
    @where_the_wild_things_are = Book.new :book_type => 'childrens book', :author => 'Maurice Sendak', :pictures => true
    @current_economist = Magazine.new :year => 2009, :month => "December"
    @bookshelf = Library.new @neuromancer, @where_the_wild_things_are
    @toilet = Library.new @neuromancer, @current_economist
    @bedstand = Library.new @neuromancer
    @catalog = Catalog.new @bookshelf, @toilet
    @anne = Librarian.new
    @seamus = Enthusiast.new
    @new_releases = Shelf.new # empty!
    @new_magazines = Rack.new # empty!
    @browsing_section = Catalog.new @new_releases, @new_magazines
  end
  
  def test_setup
    assert_equal Book, @neuromancer.class
    assert_equal Library, @bookshelf.class
    assert_equal 2, @bookshelf.books.length
    assert_equal 'accept', Verbs::Conjugator.conjugate(:accept, :tense => :present, :person => :first, :plurality => :singular)
    assert_equal 'a', 'one'.indefinite_article
  end
  
  def test_summary_definition
    assert_equal SummaryJudgement::Summary, Book.summary.class
    assert_equal Proc, Book.summary.terms.first.phrase.class
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
    assert_equal 'Has read 2 books', @bookshelf.summary(:conjugate => true, :subject => false)
    assert_equal 'You have 2 books', @bookshelf.summary(:conjugate => :second, :subject => true, :verbs => :branches)
    assert_equal 'The catalog contains 2 books and 1 magazine', @catalog.summary(:conjugate => :third, :subject => 'The catalog', :verbs => :branches)
  end
  
  def test_verbose_summaries
    assert_equal 'A novel by William Gibson and an illustrated childrens book by Maurice Sendak', @bookshelf.summary(:verbose => true)
  end
  
  def test_conjugated_verbose_summaries
    assert_equal 'I have read a novel by William Gibson and an illustrated childrens book by Maurice Sendak', @bookshelf.summary(:verbose => true, :conjugate => :first, :subject => true)
  end
  
  def test_summaries_with_adaptive_verbosity
    assert_equal '2 books', @bookshelf.summary(:verbose => :small?)
    assert_equal 'A novel by William Gibson', @bedstand.summary(:verbose => :small?)
  end
  
  def test_conjugated_summaries_with_adaptive_verbosity
    assert_equal 'They have read 2 books', @bookshelf.summary(:verbose => :small?, :conjugate => :third, :plurality => :plural, :subject => true)
    assert_equal 'They have read a novel by William Gibson', @bedstand.summary(:verbose => :small?, :conjugate => :third, :plurality => :plural, :subject => true)
  end
  
  def test_inheritance
    assert_equal 'A hardcover novel by William Gibson', @first_edition_neuromancer.summary
    assert_equal 'A librarian', @anne.summary
  end
  
  def test_lazily_inherited_summary_definitions
    assert_equal 'An avid reader', @seamus.summary
  end
  
  def test_recursive_send_core_extension
    assert_equal 'foo bar', 'foo_bar'.recursive_send(:humanize, :downcase)
  end
  
  def test_empty_state
    assert_equal 'You have an empty shelf', @new_releases.summary(:conjugate => :second, :subject => true)
  end
  
  def test_conjugated_summary_with_multiple_verbs
    assert_equal 'I have read 2 books and have skimmed 1 magazine', @catalog.summary(:conjugate => :first, :subject => true, :aspect => :perfect)
    assert_equal 'I have read a novel by William Gibson and an illustrated childrens book by Maurice Sendak and have skimmed a magazine issue from December 2009', @catalog.summary(:conjugate => :first, :subject => true, :aspect => :perfect, :verbose => true)
  end
  
  def test_delegated_placeholders
    assert_equal 'You have an empty shelf and have an empty rack', @browsing_section.summary(:conjugate => :second, :subject => true)
  end
end
