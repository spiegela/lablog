require 'yaml'
require 'net/telnet'
class ActivationsController < ApplicationController

  active_scaffold :activation do |config|
    config.columns = [:reservation, :user, :ip_address, :created_at, :completed_at, :in_use]
    config.list.columns = [:user, :ip_address, :created_at, :completed_at, :in_use]
    config.create.columns = [:user, :ip_address]

    config.columns[:created_at].label = "Start Time"
    config.columns[:completed_at].label = "End Time"

    config.columns[:user].form_ui = :select
    config.columns[:user_id].form_ui = :hidden
    config.columns[:reservation_id].form_ui = :hidden

    config.actions =  [:create, :list, :nested]

    config.action_links.add 'update',
      :type => :record, :label => 'Update Activated IP Address',
      :inline => true, :position => false,
      :crud_type=> 'update'

    config.action_links.add 'complete',
      :type => :record, :label => 'Manually End Activation',
      :inline => true, :position => false,
      :crud_type=> 'complete'
  end
  
  def check
    within_5_min_of_now = Time.now - 300

    conditions = "start_time < ? AND end_time > ? AND approved_at is not NULL"
    @reservations = Reservation.find_all_by_user_id( current_user,
      :conditions => [ conditions, within_5_min_of_now, Time.now ] )

    @reservations = @reservations.collect{|r|r unless r.activated}.compact \
      unless params[:explicit_check]
  
    if params[:excplicit_check] and @reservations.empty? 
      alert_text = "You do not have any approved reservations pending"
      render :update do |page|
        page << "if(! Windows.getFocusedWindow() ) {"
        page.call "d = Dialog.alert", alert_text,
          { :id => 'activation_window',
            :width => 400,
            :destroyOnClose => true,
            :className => "alphacube"
          }
        page << "}"
      end
    elsif not @reservations.empty?
      render :update do |page|
        page << "if(! $('activation_window') ) {"
        page.call "d = Dialog.confirm", render(:partial => 'new'),
          { :id          => 'activation_window', :width       => 400,
            :okLabel     => "Activate",
            :cancelLabel => "Later",
            :className   => "alphacube",
            :onOk        => anonymous_javascript_function(:body => 'submitForm(); d.close();'),
            :destroyOnClose => true
          }
        page << "}"
      end
    else
        render :nothing => true
    end
  end

  def create
    # Actual Firewall commands in AR callback
    if params[:from_auto_form]
      params[:record][:ip_address] = request.remote_ip
      active_scaffold_config.create.columns << :reservation_id
      active_scaffold_config.create.columns << :user_id
      do_create

      render :update do |page|
        page.call "d = Dialog.alert",
          render(:partial => 'welcome', :locals => {:record => @record}),
          { :id          => 'welcome_alert',
            :width       => 400,
            :className   => "alphacube",
            :onOk        => anonymous_javascript_function(:body => 'd.close();'),
            :destroyOnClose => true
          }
      end
    else
      super
    end
  end

  def complete
    @record = Activation.find params[:id]
    @record.completed_at = Time.now
    # Actual Firewall commands in AR callback
    if @record.save
      render :update do |page|
	page.replace "activations-list-#{params[:id]}-row", :partial => 'list_record', :locals => { :list_record => @record } 
      end
    end
  end

  def update
    @record = Activation.find params[:id]
    # Save last ip so we can delete it from the table
    @record.last_ip_address = @record.ip_address
    @record.ip_address = request.remote_ip
    # Actual Firewall commands in AR callback
    if @record.save
      render :update do |page|
	page.replace "activations-list-#{params[:id]}-row", :partial => 'list_record', :locals => { :list_record => @record } 
      end
    end
  end
end