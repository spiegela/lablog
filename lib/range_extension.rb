class Range
  def overlap?(range)
    self.include?(range.first) || range.include?(self.first)
  end

  def include_with_range?(value)
    if value.is_a?(Range)
      last = value.exclude_end? ? value.last - 1 : value.last
      self.include?(value.first) && self.include?(last)
    else
      include_without_range?(value)
    end
  end
  alias_method_chain :include?, :range
end
