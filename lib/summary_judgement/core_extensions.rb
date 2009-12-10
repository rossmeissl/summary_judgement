class String
  def indefinite_article
    if WORDS_WITH_INITIAL_VOWELS_THAT_ACT_LIKE_WORDS_WITH_INITIAL_CONSONANTS.include? first_word.first_term.downcase
      INDEFINITE_ARTICLES[:consonant]
    elsif VOWELS.include? first.downcase
      INDEFINITE_ARTICLES[:vowel]
    else
      INDEFINITE_ARTICLES[:consonant]
    end
  end

  def with_indefinite_article(upcase = false)
    "#{upcase ? indefinite_article.humanize : indefinite_article}#{ ' ' unless self.blank? }#{self}"
  end
  
  def pluralize_on(qty)
    qty.is_a?(Numeric) and qty > 1 ? pluralize : self
  end
  
  def first_word
    split(' ').first
  end
  
  def first_term
    split('-').first
  end
  
  WORDS_WITH_INITIAL_VOWELS_THAT_ACT_LIKE_WORDS_WITH_INITIAL_CONSONANTS = %w(one united)
  INDEFINITE_ARTICLES = { :vowel => 'an', :consonant => 'a'}
  VOWELS = %w(a e i o u)
end

class Object
  def recursive_send(*methods)
    return self if methods.empty?
    m = methods.shift
    send(m).recursive_send(*methods)
  end
end
