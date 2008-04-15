class Time
  def to_short_s
    # June 20, 2007 7:25 PM
    self.strftime("%B %d, %Y %I:%M %p")
  end
end
