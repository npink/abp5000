class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :require_login
      
  private
  
  def require_login
      redirect_to(controller: 'admin', action: 'login_form') if session[:logged_in].blank?
  end
  
end
