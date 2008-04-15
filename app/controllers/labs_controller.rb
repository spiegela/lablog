class LabsController < ApplicationController
  active_scaffold :lab do |config|
    config.columns = [:name, :short_name, :location, :district, :region, :division, :reservations, :assets, :grants, :firewall]
    config.list.columns = [:name, :short_name, :location, :reservations, :assets]
    config.create.columns = [:name, :short_name, :location, :district, :region, :division, :firewall, :grants]
    config.update.columns = [:name, :short_name, :location, :district, :region, :division, :firewall, :grants]
    config.columns[:location].description = "Please include address, room location, and location code where appropriate"
    config.columns[:firewall].label = "Firewall IP Address"
    config.action_links.add 'show', :label => 'Show', :page => true, :type => :record
  end

  def show
    session[:cart] ? session[:cart].clear : session[:cart] = Array.new
    super
  end

  def create_authorized?
    current_user and current_user.super_user
  end

  def update_authorized?
    current_user and (current_user.administrator or current_user.super_user)
  end

  def delete_authorized?
    current_user and (current_user.administrator or current_user.super_user)
  end
end
