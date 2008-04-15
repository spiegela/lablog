require 'yaml'
class ApprovalsController < ApplicationController
  include ActiveScaffold::AttributeParams
  STATES = {:not_auto => "require manual approval",
            :approved => "be automatically approved",
            :rejected => "be rejected" }

  def check
    @errors = []
    @state = :approved
    params[:record].delete :members
    config = active_scaffold_config_for(Reservation)
    reservation = update_record_from_params(config.model.new,
      config.create.columns, request.parameters[:record])
    reservation.usages.each {|usage| perform_usage_checks(usage) }
    perform_reservation_checks(reservation)

    render :update do |page|
      page << "if($('preApprovalStatus')){"
      page['preApprovalStatus'].className = "pre-approval-status-#{@state}"
      page['preApprovalStatus'].replace_html :partial => 'approval_status',
        :locals => {:state => @state, :errors => @errors,
        :l_state => STATES[@state]}
      page << "}"
    end
  end
  
  private

  def perform_reservation_checks(reservation)
    conflicts = reservation.find_all_conflicting
    unless conflicts.empty?
      @state = :rejected
      @errors << "Your reservation conflicts with the following:<br/>" +
	conflicts.collect{|c| c.to_listing}.join
    end
  end

  def perform_usage_checks(usage)
    errors = []
    errors << "Destructive usages must be manually approved" if usage.destructive
    errors << "Selected Asset, #{usage.asset.to_label}, is not currently active" unless usage.active?
    errors << "Asset, <em>#{usage.asset.to_label}</em>, is not currently at the selected version" unless usage.at_version?
    errors << "Asset, <em>#{usage.asset.to_label}</em>, has been previously scheduled for a destructive reservation" unless usage.no_prior?
    @state = :not_auto unless @state == :rejected or errors.empty?
    @errors += errors
  end
end
