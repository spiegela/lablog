class Designation < ActiveRecord::Base
  belongs_to :asset
  belongs_to :user

  def to_label
    "#{self.user.login}/#{self.asset.to_label}"
  end
end
