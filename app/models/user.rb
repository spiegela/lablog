require 'digest/sha1'
require 'rubygems'
require 'net/ldap'
 
class User < ActiveRecord::Base
  has_many :reservations
  has_many :activations
  has_many :approved_reservations, :class_name => "Reservation",
    :conditions => ["approval_status = ? OR approval_status = ?", "Approved", "Automatically Approved"]
  has_many :rejected_reservations, :class_name => "Reservation", :conditions => {:approval_status => "Rejected"}
  has_many :pending_reservations, :class_name => "Reservation",  :conditions => {:approval_status => "Pending"}
  has_many :grants
  has_many :labs, :through => :grants
  has_many :designations
  has_many :assets, :through => :designations
   
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login, :email
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  
  def to_label
    self.name
  end
  
  def name
    if self.first_name || self.last_name
      "#{self.first_name} #{self.last_name}"
    else
      self.login
    end
  end

  def administrator
    self.super_user or not self.grants.collect{|g| 1 if g.administrator}.compact.empty?
  end

  def administrator_labs
    self.grants.collect{|g| g.lab if g.administrator}.compact
  end

  def approver
    self.super_user or not self.grants.collect{|g| 1 if g.approver}.compact.empty?
  end

  def approver_labs
    self.grants.collect{|g| g.lab if g.approver}.compact
  end
  
  def self.can_bind_ldap?(login, password)
    attrs = ["mail", "sn", "givenName", "telephoneNumber", "l", "division"]
    userPrincipalName = login + '@corp.emc.com'
    ldap = Net::LDAP.new :host => '128.221.12.10', :port => 389,
      :auth => {
        :method => :simple,
        :username => userPrincipalName,
        :password => password
      }
    
    result = ldap.bind_as( :attributes => attrs,
      :base => "ou=US Users,dc=corp,dc=emc,dc=com",
      :filter => "(samAccountName=#{login})",
      :password => password
    )
    
    { :first_name => result.first.givenName.first,
      :last_name => result.first.sn.first,
      :email => result.first.mail.first,
      :organization => result.first.division.first,
    } if result
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = nil
    if user_attributes = can_bind_ldap?(login, password)
      u = find_or_create_by_login(login)
      u.update_attributes(user_attributes) && u.save if u.new_record?
    end
    u
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
end
