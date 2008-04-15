class AssetsController < ApplicationController
  before_filter :update_scaffold_config
  
  def update_scaffold_config
    if defined?(active_scaffold_session_storage[:constraints][:lab_id])
      active_scaffold_config.columns.exclude(:lab) 
    else
      active_scaffold_config.action_links.delete('add')
      active_scaffold_config.columns[:lab].search_sql = 'labs.name'
      active_scaffold_config.columns[:lab_id].search_sql = 'labs.short_name'
      active_scaffold_config.search.columns << :lab
      active_scaffold_config.search.columns << :lab_id
    end
  end

  active_scaffold :asset do |config|
    config.label = "Inventory"
    config.columns = [:lab, :lab_id, :name, :producer, :platform, :model,
      :serial_number, :type, :virtualized, :active, :versions, :designations,
      :registration_key]
    config.list.columns = [:lab, :type, :name, :platform, :model, :versions ]
    config.create.columns = [:lab_id, :name, :platform, :model,
      :serial_number, :type, :active, :virtualized, :versions, :designations,
      :registration_key]
    config.update.columns = [:lab_id, :name, :platform, :model,
      :serial_number, :type, :virtualized, :versions, :designations,
      :registration_key]
    config.show.columns = [:lab, :name, :platform, :model,
      :serial_number, :type, :virtualized, :versions, :designations,
      :registration_key]
    config.show.columns = [:lab, :name, :platform, :model,
      :serial_number, :type, :virtualized, :versions, :designations]
    config.columns[:designations].label = 'Maintainers'
  end

  def do_search
    if params[:search] == 'available_now'
      self.active_scaffold_conditions = merge_conditions(
	self.active_scaffold_conditions,
	['assets.id IN (?)', Asset.available_asset_ids]
      )
    else
      super
    end
  end

  def load_listing  
    begin
      @lab = Lab.find(active_scaffold_session_storage[:constraints][:lab_id])
      active_scaffold_config.action_links.exclude :update unless
        @lab.administrators.include?(current_user)
    rescue
      @lab = Lab.new
    end
  end
  
  def before_create_save(record)
    record.lab_id = @lab.id if @lab
  end

  def create_authorized?
    current_user and current_user.administrator
  end

  def update_authorized?
    current_user and current_user.administrator
  end

  def delete_authorized?
    current_user and current_user.administrator
  end
end