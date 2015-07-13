class UsersController < ApplicationController
    layout false
    skip_before_action :require_login
    
    def fixtures
       User.fixtures
       
       redirect_to :root
    end
  
    def reset
       User.reset
       
       redirect_to :root
    end
    
    def login_form
    end
    
    def login
        user = User.first
        if params[:initials] == user.initials and params[:password] == user.password
            session[:initials] = params[:initials]
            redirect_to :controller => 'tasks', :action => 'render_queue'
        else
            @error = "Incorrect password"
            render 'login_form'
        end
    end
    
end