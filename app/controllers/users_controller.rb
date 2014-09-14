class UsersController < ApplicationController
    def login_form
        
    end
    
    def login
        redirect_to :controller => 'orders', :action => 'list_by_date'
    end
    
    def logout
        
    end
end
