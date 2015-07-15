class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :require_login
  before_filter :create_task_object
  before_filter :get_latest_news
      
  private
  
  def require_login
      redirect_to(controller: 'users', action: 'login_form') if session[:initials] == nil
  end
  
  def create_task_object
     @task = Task.new
  end
  
  def get_latest_news
     @latest_news = Comment.where('created_at > ?', Time.now - 12.hours).order(created_at: :desc)
    
  end
end
