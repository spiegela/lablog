class ReservationsController < ApplicationController
  active_scaffold :reservation do |config|
    config.columns = [ :user, :event, :start_time, :end_time, 
      :reason, :usages, :user_id, :comment, :usages,
      :approval_status, :approvers_comments, :lab, :activations,
      :members ]

    config.list.columns = [ :user, :event, :start_time, :reason, :usages,
      :approval_status, :activations]
    list.sorting = {:start_time => 'DESC'}
    list.per_page = 5

    config.show.columns = [ :lab, :user, :event, :start_time, :end_time, 
      :reason, :usages, :comment, :usages, :members, :activations,
      :approval_status, :approvers_comments ]

    config.create.columns = [ :user_id, :event, :reason, :start_time,
      :end_time, :comment, :usages, :members ]

    config.update.columns = [ :user_id, :event, :reason, :start_time,
      :end_time, :comment, :usages, :members, :approval_status,
      :approvers_comments]

    config.create.link.action = 'new'
    config.create.link.inline = true
    config.create.link.position = false

    config.action_links.add 'review', :type => :record, :label => 'Review'

    config.columns[:start_time].form_ui = :dhtml_calendar
    config.columns[:end_time].form_ui = :dhtml_calendar
  end

  def review_authorized?
    return false unless current_user
    begin
      lab_id = active_scaffold_session_storage[:constraints][:lab_id]
      return true if lab_id and Lab.find(lab_id).approvers.include?(current_user)
    rescue
      return false
    end
  end

  def create_authorized?
    current_user
  end

  def update_authorized?
    current_user
  end

  def delete_authorized?
    current_user
  end

  def list
    @controller_id = "reservations"
    active_scaffold_config.action_links.exclude(:create) if params[:nested]
    super
  end

  def edit
    active_scaffold_config.update.columns.exclude [ :approval_status,
      :approvers_comments ] unless @review
    super
  end

  def conditions_for_collection
    if params[:user_id]
      ["user_id = ?", params[:user_id] ]
    end
  end

  def new
    if params[:quick]
	asset = Asset.find(params[:id])
	lab = @lab ? @lab : asset.lab
# I like this way better, but Usages & Activations don't translate over
# 
#	  @record = Reservation.new
#	  @record.usages << Usage.new(:asset => asset )
#	  params[:record] = {
#	    :start_time => Time.now, :end_time => (Time.now + 1800),
#	    :event => 'Quick reservation', :reason => 'Quick reservation',
#	    :user_id => current_user.id, :lab_id => lab.id
#	  }
#	  create
      # Same as do create since except we're creating our own @record (not from params)
      Reservation.transaction do
	begin
	  @record = Reservation.new(
	    :start_time => Time.now, :end_time => (Time.now + 1800),
	    :event => 'Quick reservation', :reason => 'Quick reservation',
	    :user_id => current_user.id, :lab_id => lab.id)
	  @record.usages << Usage.new(:asset => asset, :version => asset.current_version)
	  @record.activations.create :ip_address => request.remote_ip, :user_id => current_user.id
	  before_create_save(@record)
          self.successful = [@record.valid?, @record.associated_valid?].all? {|v| v == true} # this syntax avoids a short-circuit
          if successful?
            @record.save! and @record.save_associated!
            after_create_save(@record)
          end
	rescue ActiveRecord::RecordInvalid
        end
      end
      # skip create action, and skip to adding it to the table
      render :action => 'create.rjs'
    else
      # follow the normal ActiveScaffold course but w/ new.rjs/create.rjs overrides (a JS window)
      @record = Reservation.new
      @record.usages << session[:cart].collect{|asset| Usage.new(:asset => asset)}
    end
  end

  def review
    if params[:approval_code]
      @record = Reservation.find_by_approval_code(params[:approval_code])
    else
      @record = Reservation.find(params[:id])
    end

    if @record.lab.approvers.include?(current_user)
      @review = true
      # a Review is a special update with different columns
      active_scaffold_config.update.columns.exclude [ :user_id, :reason,
	:start_time, :end_time, :comment, :usages ]
      edit
    else
      render :nothing
    end
  end

end
