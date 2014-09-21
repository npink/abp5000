class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :require_login
      
  private
  
  def require_login
      redirect_to(controller: 'users', action: 'login_form') if session[:initials] == nil
  end
  
end
