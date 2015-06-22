class UsersController < ApplicationController
    layout false
    skip_before_action :require_login
    
    def login_form
    end
    
    def login
        user = User.first
        if params[:initials] == user.initials and params[:password] == user.password
            session[:initials] = params[:initials]
            redirect_to :controller => 'tasks', :action => 'render_queue'
        else
            render 'login_form'
        end
    end
    
    def logout
        session[:initials] = nil
        redirect_to action: 'login_form'
    end
end