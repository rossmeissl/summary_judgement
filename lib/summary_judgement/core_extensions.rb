class String
  def indefinite_article
    %w(a e i o u).include?(first.downcase) &&
      !::String::WORDS_WITH_INITIAL_VOWELS_THAT_ACT_LIKE_WORDS_WITH_INITIAL_CONSONANTS.include?(self.sub('-', ' ').split(' ').first.downcase) ? 'an' : 'a'
  end

  def with_indefinite_article(upcase = false)
    "#{upcase ? indefinite_article.humanize : indefinite_article}#{ ' ' unless self.blank? }#{self}"
  end
  
  def pluralize_on(qty)
    qty.is_a?(Numeric) and qty > 1 ? pluralize : self
  end
  
  WORDS_WITH_INITIAL_VOWELS_THAT_ACT_LIKE_WORDS_WITH_INITIAL_CONSONANTS = %w(one)
end

class Object
  def recursive_send(*methods)
    return self if methods.empty?
    m = methods.shift
    send(m).recursive_send(*methods)
  end
end
