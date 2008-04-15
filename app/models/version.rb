class Version < ActiveRecord::Base
  belongs_to :asset
  has_many :usages

  def to_label
    self.version
  end

  def authorized_for_create?
    return false unless current_user
    return false if self.asset and self.asset.lab and not self.asset.lab.administrators.include?(current_user)
    return false unless current_user.administrator
    return true
  end

  def authorized_for_destroy?
    return false unless current_user
    return true unless existing_record_check?
    return false if self.asset and self.asset.lab and not self.asset.lab.administrators.include?(current_user)
    return false unless current_user.administrator
    return true
  end

  def authorized_for_update?
    return false unless current_user
    return true unless existing_record_check?
    return false if self.asset and self.asset.lab and not self.asset.lab.administrators.include?(current_user)
    return false unless current_user.administrator
    return true
  end
end
