class EquipmentController < AssetsController
  active_scaffold :equipment do |config|
    config.columns = [:lab, :lab_id, :name, :producer, :platform, :model,
      :operating_system, :serial_number, :versions, :active, :designations,
      :reservations, :interfaces]

    config.create.columns = config.update.columns = [:lab_id, :name, :producer,
      :platform, :model, :operating_system, :serial_number, :active, :interfaces,
      :versions, :designations]

    config.list.columns = [:lab, :name, :producer, :platform, :model,
      :operating_system, :versions, :interfaces, :active]
    config.list.per_page  = 6

    config.columns[:producer].label = "Manufacturer"
    config.columns[:designations].label = "Maintainers"
    config.columns[:versions].label = "Code / Firmware"

    config.columns[:active].form_ui = :checkbox

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
end