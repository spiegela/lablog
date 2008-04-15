class VersionsController < ApplicationController
    config.columns = [:version, :currently_at_this_version, :asset]
    config.subform.columns = [:version, :currently_at_this_version]
    config.columns[:currently_at_this_version].form_ui = :checkbox
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
