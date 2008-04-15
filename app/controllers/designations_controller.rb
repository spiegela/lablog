class DesignationsController < ApplicationController
  active_scaffold :designation do |config|
    config.create.columns = [:user, :asset, :primary_contact]
    config.subform.columns = [:user, :primary_contact]
    config.columns[:primary_contact].form_ui = :checkbox
  end
end
