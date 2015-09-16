class AdminController < ApplicationController
   layout false
   skip_before_action :require_login
   
   
   def login_form
   end
   
   def login
        if params[:password] == Rails.application.config.password
           session[:logged_in] = true
           redirect_to :controller => 'tasks', :action => 'dashboard'
        else
           @error = "Incorrect password"
           render 'login_form'
       end
   end
   
   def logout
      session[:logged_in] = nil
      redirect_to :action => 'login_form'
   end
   
   def normalize_attributes
      Task.all.each do |t|
         puts t.client_name
         t.delegated_to = nil if t.delegated_to.blank?
         t.completed_by = nil if t.completed_by.blank?
         t.completed_on = nil if t.completed_on.blank?
         t.save
      end
   end
   
   def test
      @active_users = Set.new
      @users = Task.select(:delegated_to, :completed_by).
         where("iced = ? AND (( delegated_to IS NOT NULL AND completed_by IS NULL) OR completed_on = ?)", false, Date.today).
         group(:delegated_to, :completed_by)
         @users.each do |u|
            @active_users.add(u.delegated_to.upcase) rescue nil
            @active_users.add(u.completed_by.upcase) rescue nil
         end
         @active_users
   end
   
   def fixtures
      User.delete_all
      Task.delete_all

      User.create :initials => 'staff', :password => 'playgolf20142014'

      tasks = [
         {client_name: 'Action Property', summary: 'added 7 days ago, no due date', created_at: (Time.now - 7.days) },
         {client_name: 'Barnes Solar', summary: 'added 5 days ago', created_at: (Time.now - 5.days) },
         {client_name: '100 Black Men', summary: 'added 6 days ago', created_at: (Time.now - 6.days) },
         {client_name: 'Ganahl Lumber', summary: 'due today', due_date: Date.today},
         {client_name: 'Solar City', summary: 'done today', delegated_to: 'SS', completed_by: 'NP', completed_on: Date.today},
         {client_name: 'Wesierski & Zurich', summary: 'done today', delegated_to: 'KF', completed_by: 'DP', completed_on: Date.today},
         {client_name: 'Universal Protection', summary: 'done yesterday', delegated_to: 'SS', completed_by: 'DP', completed_on: (Date.today - 1) },
         {client_name: 'OC Sheriffs', summary: 'due tomorrow', due_date: Date.today.next},
         {client_name: 'Geary Pacific', summary: 'added today,due in 3 days', due_date: Date.today + 3},
         {client_name: 'Mammoth Mountain', summary: 'due in 3 days', due_date: Date.today + 3},
         {client_name: 'Placentia Little League', summary: 'due in 5 days', due_date: (Date.today + 5) },
         {client_name: 'Valencia HS', summary: 'due in 4 days', due_date: (Date.today + 4) },
         {client_name: 'Cal State Fullerton', summary: 'added yesterday, due in 3 days', due_date: (Date.today + 3), created_at: (Time.now - 1.days)},
         {client_name: 'City of Anaheim', duration: '8', summary: 'done yesterday', completed_by: 'SS', delegated_to: 'NP', completed_on: (Date.today - 2) },
         {client_name: 'Casablanca', summary: 'due in 2 days', due_date: (Date.today + 2) },
         
      ]
      tasks.each do |t|
         Task.create t
      end
      
      Comment.create( {body: "8 day old comment", created_at: (Date.today - 8)} )
      
      render :nothing => true
   end
   
   def reset
      User.delete_all
      Task.delete_all

      User.create :initials => 'staff', :password => 'playgolf20142014'
      
      render :nothing => true
   end
end