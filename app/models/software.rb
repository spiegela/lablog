class Software < Asset
  has_many :hardware_dependencies
  has_many :required_equipment, :through => :hardware_dependencies, :source => :equipment

  validates_presence_of :producer

  PRODUCERS = [:EMC, :symmantec, :microsoft, :oracle,
    :EMC_legato, :vmware, :sun_microsystems, :ibm,
    :hp, :EMC_smarts, :RSA]

  def self.producers
    PRODUCERS.collect{|x|x.to_s.humanize}
  end
        
  def to_label
    [self.producer, self.name].join(' ')
  end
end
