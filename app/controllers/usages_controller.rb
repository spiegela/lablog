class UsagesController < ApplicationController
  active_scaffold :usage do |config|
    config.columns = [:asset, :version, :destructive, :exclusive, :reservation]
    config.subform.columns = [:asset, :version, :destructive, :exclusive]
    config.columns[:destructive].form_ui = :checkbox
    config.columns[:exclusive].form_ui = :checkbox
    config.actions.exclude :update, :create
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
end
