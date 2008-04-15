class InterfacesController < ApplicationController
  active_scaffold :interface do |config|
    config.columns = [:ip_address, :hostname, :name, :primary, :asset]
    config.columns[:name].label = 'Physical Interface Name'
    config.columns[:primary].form_ui = :checkbox
  end
end
