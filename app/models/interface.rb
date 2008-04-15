class Interface < ActiveRecord::Base
  belongs_to :asset

  def to_label
    label = ip_address
    label += " (#{name})" if name
    label
  end
end
