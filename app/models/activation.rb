require 'socket'
require 'stringio'
require 'timeout'

class Activation < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :user
  FW_CMD_PORT = 4000

  def last_ip_address=(ip_address)
    @last_ip_address = ip_address
  end

  def in_use
    (send_fw_cmd("show:#{self.ip_address}") != "0 no states\n")
  end

  def after_create
    # Execute actual firewall table changes (if needed)
    send_fw_cmd "add:" + self.ip_address
  end

  def after_update
    # Execute firewall table changes for an IP address update
    if @last_ip_address
      send_fw_cmd "add:" + self.ip_address

      send_fw_cmd "del:" + @last_ip_address
    end

    # Remove firewall table entry for manually ended or old entry on update
    if self.completed_at
      send_fw_cmd "del:" + self.ip_address
      send_fw_cmd "kill:" + self.ip_address if self.in_use
    end

  end

  def to_label
    "#{ip_address} @ #{created_at}"
  end

  def lab
    self.reservation.lab
  end

  def authorized_for?(action)
    if action[:action]== "complete" or action[:action]== "update"
      return false if self.completed_at
      return false unless self.user_level_authorized
      return true
    else
      super
    end
  end

  def user_level_authorized
    current_user.super_user or 
      self.user == current_user or
	self.reservation.user == current_user or 
	  self.reservation.lab.administrator == current_user
  end

  private

  def send_fw_cmd(cmd_str)
    result = nil
    sock = nil
    timeout(10) do 
      sock = TCPSocket.open(self.reservation.lab.firewall, FW_CMD_PORT)
      sock.write("#{cmd_str}\n")
      result = StringIO.new(sock.read)
    end
    sock.close
    raise "Firewall Interface Encountered Error" if result == "0 error\n"
    return result.read
  end
end