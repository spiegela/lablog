class Lab < ActiveRecord::Base
  has_many :reservations
  has_many :assets
  has_many :equipment
  has_many :softwares
  has_many :grants
  has_many :designations

  DIVISIONS = [:midwest, :west, :mid_atlantic, :north_east, :latin_amertica, :federal]
  ACCESS_TYPES = [:single_ip_nat, :routable_addresses_no_nat, :nat_address_pool]

  def self.divisions
    DIVISIONS.collect{|d| d.to_s.humanize}
  end

  def self.access_types
    ACCESS_TYPES.collect{|a| a.to_s.humanize}
  end

  def self.to_select
    Lab.find(:all).collect{|l| [l.name, l.id]}
  end

  def to_label
    self.name
  end

  def approvers
    self.grants.find(:all, :conditions => {:approver => true}).collect{|g|g.user}
  end

  def administrators
    self.grants.find(:all, :conditions => {:administrator => true}).collect{|g|g.user}
  end

  def authorized_for_create?
    return false unless current_user
    return true unless existing_record_check?
    return false unless current_user.super_user
    return true
  end

  def authorized_for_update?
    return false unless current_user
    return true unless existing_record_check?
    #return true if self.administrators.include?(current_user)
    return false unless current_user.super_user
    return true
  end

  def authorized_for_destroy?
    return false unless current_user
    return true unless existing_record_check?
    return false unless current_user.super_user
    return true
  end
end
