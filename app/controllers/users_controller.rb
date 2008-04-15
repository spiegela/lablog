class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  skip_before_filter :login_required

  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie

  def update_authorized?
    current_user and current_user.super_user
  end
  
  def delete_authorized?
    current_user and current_user.super_user
  end
  
  active_scaffold :user do |config|
    config.columns = [:first_name, :last_name, :name, :login, :email, :organization, :grants, :designations]
    config.create.columns = [:first_name, :last_name, :login, :email, :organization, :grants, :designations]
    config.update.columns = [:first_name, :last_name, :login, :email, :organization, :grants, :designations]
    config.list.columns = [:name, :login, :email, :organization, :grants]
    config.actions.exclude :nested, :create
  end

  record_select :per_page => 5, :search_on => [:first_name, :last_name, :login, :email]

  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_to("/lablog")
      flash[:notice] = "Logged in successfully"
    end
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => 'users', :action => 'login')
  end
 
end
