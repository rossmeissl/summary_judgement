require 'rubygems'
require 'test/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'summary_judgement'

class Test::Unit::TestCase
end

class Book
  attr_reader :book_type, :author, :color, :length_in_pages, :pictures
  def initialize(options = {})
    @book_type = options[:book_type]
    @author = options[:author]
    @color = options[:color]
    @length_in_pages = options[:length_in_pages]
    @pictures = options[:pictures]
  end
  
  extend SummaryJudgement
  summarize do |has|
    has.adjective :color
    has.adjective 'illustrated', :if => :pictures
    has.adjective lambda { |book| "#{book.length_in_pages}pp" }, :if => :length_in_pages
    has.identity lambda { |book| book.book_type }
    has.modifier lambda { |book| "by #{book.author}" }, :if => :author
  end
end

class Library
  attr_reader :books
  def initialize(*volumes)
    @books = volumes
  end
  
  extend SummaryJudgement
  summarize do |has|
    has.children :books
  end
end
