class GrantsController < ApplicationController
  active_scaffold :grant do |config|
    config.columns = [:user, :lab, :approver, :administrator]
    config.columns[:approver].form_ui = :checkbox
    config.columns[:administrator].form_ui = :checkbox
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
