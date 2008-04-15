class HardwareDependency < ActiveRecord::Base
  belongs_to :software
  belongs_to :equipment

  def to_label
    self.equipment.to_label
  end
end
