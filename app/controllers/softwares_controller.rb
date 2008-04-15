class SoftwaresController < AssetsController
  active_scaffold :software do |config|

    config.columns = [:lab, :lab_id, :name, :producer, :versions, :active,
      :virtualized, :registration_key, :designations, :hardware_dependencies]

    config.create.columns = config.update.columns = [:lab_id, :name, :producer,
      :active, :virtualized, :registration_key, :versions, :designations,
      :hardware_dependencies]

    config.list.columns = [:lab, :name, :producer, :versions, :hardware_dependencies,
      :active, :virtualized]
    config.list.per_page  = 6

    config.columns[:active].form_ui = :checkbox
    config.columns[:virtualized].form_ui = :checkbox

    config.columns[:designations].label = "Maintainers"
    config.columns[:hardware_dependencies].label = "Dependencies"

    config.action_links.add 'add',
      :type => :record, :label => 'Reserve',
      :position => false,
      :parameters => {:controller => 'reservations_cart'}

    config.action_links.add 'new',
      :type => :record, :label => 'Quick Reserve',
      :position => false, :crud_type=> 'quick_reserve',
      :parameters => {:controller => 'reservations', :quick => true}

    config.action_links.add 'update_table',
      :type => :table, :label => 'Available Now',
      :position => :top, :inline => true,
      :parameters => {:commit => 'Search', :search => 'available_now'}
  end

  def load_listing  
    begin
      @lab = Lab.find(active_scaffold_session_storage[:constraints][:lab_id])
      active_scaffold_config.action_links.exclude :update unless @lab.administrators.include?(current_user)
    rescue
      @lab = Lab.new
    end
    
  end
end
