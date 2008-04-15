module LabsHelper
  def division_form_column(record, input_name)
    select :record, :division, Lab.divisions, :name => input_name
  end

  def location_form_column(record, input_name)
    text_area(:record, :location, :name => input_name, :cols => 45, :rows => 2, :style => "font-size: 1em")
  end

  def assets_column(record)
    link_str = "#{record.assets.length} Assets: #{record.equipment.length} Equipment/#{record.softwares.length} Software"
    link_to link_str, {:action => 'nested', :associations => 'assets', :id => record.id},
      :class => "nested action", "position" => "after", :id => "labs-nested-#{record.id}-link" 
  end

  def reservations_column(record)
    link_str = "#{record.reservations.length} Reservations"
    link_to link_str, {:action => 'nested', :associations => 'reservations', :id => record.id},
      :class => "nested action", "position" => "after", :id => "labs-nested-#{record.id}-link" 
  end
end
