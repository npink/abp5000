class AdminController < ApplicationController
   layout false
   skip_before_action :require_login
   
   def test
      WorkDate.get(3)
      
      render :nothing => true
   end
end