class Grant < ActiveRecord::Base
  belongs_to :lab
  belongs_to :user

  def to_label
    "#{self.user.login}/#{self.lab.short_name}" if self.lab and self.user
  end

  def authorized_for_create?
    return false unless current_user
    return true unless existing_record_check?
    return false unless self.lab.administrators.include?(current_user) || current_user.super_user
    return true
  end

  def authorized_for_update?
    return false unless current_user
    return true unless existing_record_check?
    return false unless self.lab.administrators.include?(current_user) || current_user.super_user
    return true
  end

  def authorized_for_destroy?
    return false unless current_user
    return true unless existing_record_check?
    return false unless self.lab.administrators.include?(current_user) || current_user.super_user
    return true
  end

end
