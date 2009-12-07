class String
  def indefinite_article
    %w(a e i o u).include?(first.downcase) ? 'an' : 'a'
  end

  def with_indefinite_article(upcase = false)
    "#{upcase ? indefinite_article.humanize : indefinite_article}#{ ' ' unless self.blank? }#{self}"
  end
  
  def pluralize_on(qty)
    qty.is_a?(Numeric) and qty > 1 ? pluralize : self
  end
end

class Object
  def recursive_send(*methods)
    return self if methods.empty?
    m = methods.shift
    send(m).recursive_send(*methods)
  end
end
