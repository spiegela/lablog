# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  
  # From acts_as_auth
  include AuthenticatedSystem
  
  session :session_key => '_lablog_session_id'
  before_filter :login_required
end
