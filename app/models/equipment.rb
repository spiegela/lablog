class Equipment < Asset
  has_many :hardware_dependencies
  has_many :dependent_softwares, :through => :hardware_dependencies, :source => :software
  validates_presence_of :platform

  PLATFORMS = [:centera, :celerra, :centera, :clariion,
    :symmetrix, :fiber_channel, :server, :clariion_disk_library,
    :mainframe_disk_library, ]

  def self.platforms
    PLATFORMS.collect{|x|x.to_s.humanize}
  end
        
  def to_label
    [self.platform, self.name].join(' ')
  end
  
  def authorized_for?(action)
    if action[:action]=="quick_reserve"
      return false unless self.available_now?
      return true
    else
      super
    end
  end
end
