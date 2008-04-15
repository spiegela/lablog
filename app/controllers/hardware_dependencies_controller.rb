class HardwareDependenciesController < ApplicationController
  active_scaffold :hardware_dependency do |config|
    config.columns = [:software, :equipment, :exclusive, :optional,
      :destructive]
    config.create.columns = [:equipment, :exclusive, :optional, :destructive]
    config.update.columns = [:equipment, :exclusive, :optional, :destructive]
    config.list.columns = [:equipment, :exclusive, :optional, :destructive]
    config.columns[:equipment].form_ui = :select
    config.columns[:exclusive].form_ui = :checkbox
    config.columns[:optional].form_ui = :checkbox
    config.columns[:destructive].form_ui = :checkbox
  end
end
