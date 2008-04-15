require 'range_extension'
require 'time_extension'
class Reservation < ActiveRecord::Base
  belongs_to :lab
  belongs_to :user  
  has_many :usages
  has_many :assets,    :through => :usages
  has_many :activations

  has_many :equipment, :through => :usages,
    :source => :asset,
    :conditions => 'assets.type = "Equipment"'

  has_many :software,         :through => :usages,
    :source => :asset,
    :conditions => 'assets.type = "Software"'

  has_and_belongs_to_many :members, :class_name => 'User',
    :join_table => 'reservations_members'

  validates_presence_of :reason, :start_time, :end_time

  def validate
    check_for_conflicts
  end

  def validate_on_create
    errors.add_to_base "Reservations cannot begin or end in the past" \
      if self.start_time < (Time.now - 300) or self.end_time < (Time.now - 300)
    errors.add_to_base "Reservation end time must be after the start time" if self.start_time >= self.end_time
  end

  before_create :make_approval_code

  APPROVAL_STATUSES = [:pending, :approved, :rejected]

  EVENTS = [ :beta_testing, :customer_demo, :lab_setup, :problem_recreation, :script_development, 
   :activity_setup, :certified_training, :non_certified_training, :pre_ga_training, :skill_refresh_training,
   :third_party_training_given, :third_party_training_received, :procedure_testing, :code_verification,
   :lab_hardware_replacement, :lab_code_upgrade, :lab_config_change, :quick_resevation ]

  def self.approval_statuses
    APPROVAL_STATUSES.collect{|x|x.to_s.humanize}
  end

  def self.events
    EVENTS.collect{|x|x.to_s.humanize}
  end

  def authorized_for_create?
    return false unless current_user
    return true
  end

  def authorized_for_destroy?
    return false unless current_user
    return true unless existing_record_check?
    return false unless current_user == self.user || self.lab.approvers.include?(current_user)
    return true
  end

  def authorized_for_update?
    return false unless current_user
    return true unless existing_record_check?
    return false unless current_user == self.user || self.lab.approvers.include?(current_user)
    return true
  end

  def to_listing
    <<-END_OF_STRING
<span class="listing">
Reservation from <span class="hl">#{self.start_time.to_short_s} to #{self.end_time.to_short_s}</span>
using the following assets:<br/>
<ul id="reservation-label-#{self.id}">
#{self.assets.collect{|x|'<li>' + x.to_label + '</li>' }.join}
</ul>
</span>
    END_OF_STRING
  end

  def assets
    self.usages.collect{|u| u.asset}
  end

  def exclusive_assets
    self.usages.collect{|u| u.asset if u.exclusive or u.destructive}.compact
  end

  def approval_status=(status)
    @recent_approval_status = status
    approved_at = (status == "Approved" or status == "Automatically Approved") ? Time.now : nil
    write_attribute(:approval_status, status)
    write_attribute(:approved_at, approved_at)
  end
  
  def recently_approved?
      @recent_approval_status == "Approved" or @approval_status == "Automatically Approved"
  end

  def recently_rejected?
      @recent_approval_status == "Rejected"
  end

  def to_range
    self.start_time..self.end_time
  end

  def activated
    self.activated_at ? true : false
  end

  def activated_at
    unless self.activations.empty?
	self.activations.find(:first,
	  :order => 'created_at DESC', :limit => 1).created_at
    end
  end

  def self.find_all_future
    Reservation.find(:all, :conditions => ["end_time > ?", Time.now])
  end

  def self.find_all_within_30_min
    Reservation.find(:all, :conditions =>
      ["start_time < ? AND end_time > ? and approved_at is not NULL",
      Time.now + 1800, Time.now]
    )
  end

  def self.exclusive_assets_within_30_min
    Reservation.find_all_within_30_min.collect{|r|r.exclusive_assets}.flatten
  end

  def find_all_overlapping
    Reservation.find_all_future.collect{|r|
      r if(self.to_range.overlap?( r.to_range ) and self != r)}.compact
  end

  def find_all_prior
    Reservation.find(:all, :conditions => ["end_time > ? AND end_time < ?", Time.now, self.start_time])
  end

  def find_all_after
    Reservation.find(:all, :conditions => ["end_time > ? AND start_time > ?", Time.now, self.start_time])
  end

  def find_all_conflicting
    self.find_all_overlapping.collect{|r|
      r unless (self.exclusive_assets & r.assets).empty? and
        (self.assets & r.exclusive_assets).empty? }.compact
  end

  def find_all_conflicting_within_30_min
    self.end_time = Time.now + 1800
    self.find_all_conflicting
  end

  def auto_approvable
    not self.usages.collect{ |u|
      u.availability(:version => u.version, :start_time => self.start_time) and
        not u.destructive }.include?(false)
  end

  protected

  def make_approval_code
    self.approval_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    self.approval_status = "Pending"
  end

  private

  def check_for_conflicts
    conflicts = self.find_all_conflicting
    unless conflicts.empty?
      errors.add_to_base "Your reservation conflicts with the following:<br/>#{conflicts.collect{|c| c.to_listing}.join}"
    end
  end
end
