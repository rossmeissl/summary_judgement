class String
  def indefinite_article
    %w(a e i o u).include?(first.downcase) ? 'an' : 'a'
  end

  def with_indefinite_article(upcase = false)
    "#{upcase ? indefinite_article.humanize : indefinite_article} #{self}"
  end
  
  def pluralize_on(qty)
    qty.is_a?(Numeric) and qty > 1 ? pluralize : self
  end
end
