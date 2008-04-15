class Asset < ActiveRecord::Base
  belongs_to :lab
  has_many :usages
  has_many :reservations, :through => :usages
  has_many :versions
  has_many :designations
  has_many :maintainers, :through => :designations, :source => :user
  has_many :interfaces

  validates_presence_of :name 

  ASSET_TYPES = [:Equipment, :Software]

  def self.types
    ASSET_TYPES.collect{|x|x.to_s.humanize}
  end

  def authorized_for_create?
    return false unless current_user
    return true unless existing_record_check?
    return false unless current_user.administrator
    return false if self.lab and not self.lab.administrators.include?(current_user)
    return true
  end

  def authorized_for_destroy?
    return false unless current_user
    return true unless existing_record_check?
    return false unless current_user.administrator
    return false if self.lab and not self.lab.administrators.include?(current_user)
    return true
  end

  def authorized_for_update?
    return false unless current_user
    return true unless existing_record_check?
    return false unless current_user.administrator
    return false if self.lab and not self.lab.administrators.include?(current_user)
    return true
  end

  def authorized_for?(action)
    if action[:action]=="quick_reserve"
      return false unless self.available_now?
      return true
    else
      super
    end
  end 

  def current_versions
    self.versions.find_all_by_currently_at_this_version true
  end

  def current_version
    self.current_versions.first
  end

  def prior_destructive_reservations(start_time)
    self.usages.find( :all, :include => "reservation", :conditions => [
      "destructive = 1 AND reservations.end_time > ? AND reservations.start_time < ?",
      Time.now,
      start_time ] )
  end

  def active_reservations
    self.reservations.find( :all, :include => 'activations', :conditions =>
      [ "start_time < ? AND activations.completed_at is NULL", Time.now + 1800 ])
  end

  def exclusive_reservations
    self.reservations.find( :all, :include => 'usages', :conditions =>
      [ "start_time < ? AND usages.destructive is not NULL", Time.now + 1800 ])
  end

  def self.available_assets
    Asset.find(:all).collect{|a|a if a.available_now?}.compact
  end

  def self.available_asset_ids
    Asset.find(:all).collect{|a|a.id if a.available_now?}.compact
  end

  def availability(options = nil) # opts include :version, :start_time
    active_check and
      version_check(options[:version]) and
        prior_reservation_check(options[:start_time])
  end

  def version_check(version)
    unless self.current_versions.include?(version)
      return false
    end
    true
  end

  def prior_reservation_check(start_time)
    unless self.prior_destructive_reservations(start_time).empty?
       return false
    end
    true
  end

  def active_check
    unless self.active
       return false 
    end
    true
  end

  def available_now?
    self.exclusive_reservations.empty? and self.active
  end
end
