require 'rubygems'
require 'test/unit'
require 'ruby-debug'

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

class Hardcover < Book
  summarize do |has|
    has.adjective 'hardcover'
  end
end

class Magazine
  attr_reader :length_in_pages, :year, :month
  def initialize(options = {})
    @length_in_pages = options[:length_in_pages]
    @year = options[:year]
    @month = options[:month]
  end
  
  def date
    "#{month} #{year}".strip
  end
  
  extend SummaryJudgement
  summarize do |has|
    has.adjective lambda { |magazine| "#{magazine.length_in_pages}pp" }, :if => :length_in_pages
    has.identity 'magazine issue'
    has.modifier lambda { |magazine| "from #{magazine.date}" }, :if => :date
  end
end

class Library
  attr_reader :books, :magazines
  def initialize(*volumes)
    @books = volumes.select {|v| v.is_a? Book}
    @magazines = volumes.select {|v| v.is_a? Magazine}
  end
  
  def small?
    @books.length + @magazines.length < 2
  end
  
  extend SummaryJudgement
  summarize do |has|
    has.children :books
    has.children :magazines
    has.verb :have
  end
end

class Catalog
  attr_reader :libraries
  def initialize(*libraries)
    @libraries = libraries
  end
  
  extend SummaryJudgement
  summarize do |has|
    has.children :libraries
    has.verb :contain
  end
end

class Employee
  extend SummaryJudgement
end

class Librarian < Employee
  summarize do |has|
    has.identity 'bookworm'
  end
end
