require 'pretty_table'
class Usage < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :asset
  belongs_to :version

  def to_label
    self.asset.to_label
  end

  def version_check
    self.asset.version_check(self.version) if self.version
  end

  alias at_version? version_check

  def prior_reservation_check
    self.asset.prior_reservation_check(self.reservation.start_time) \
      if self.reservation && self.reservation.start_time
  end

  alias no_prior? prior_reservation_check

  def active_check
    self.asset.active_check
  end

  alias active? active_check

  def availability(options = nil) # opts include :version, :start_time
    self.asset.availability(options)
  end

  def authorized_for_create?
    return false unless current_user
    return true
  end

  def authorized_for_destroy?
    return false unless current_user
    return true unless existing_record_check?
    return false if self.reservation and not
      ( current_user == self.reservation.user or self.reservation.lab.approvers.include?(current_user) )
    return true
  end

  def authorized_for_update?
    return false unless current_user
    return true unless existing_record_check?
    return false if self.reservation and not
      ( current_user == self.reservation.user or self.reservation.lab.approvers.include?(current_user) )
    return true
  end
end
