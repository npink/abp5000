class TasksController < ApplicationController
   
     before_filter :get_latest_news
    
    # Render all tasks that incomplete and undelegated
    def render_queue
       
       if params[:user].blank?
          # First find orders that are due within 2 days of today
          @tasks = Task.where("completed_on IS NULL AND due_date <= ? AND delegated_to IS NULL", WorkDate.get(2) ).
             order(:due_date).all
          # Second, sort remaining orders by creation date, oldest to newest
          @tasks += Task.where("completed_on IS NULL AND iced = ? AND (due_date IS NULL OR due_date > ?) AND delegated_to IS NULL", 
             false, WorkDate.get(2) ).
             order(created_at: :asc).all
          # Last, get frozen orders not due within 2 days
          @tasks += Task.where( "completed_on IS NULL AND delegated_to IS NULL AND iced = ? AND due_date > ?", true, WorkDate.get(2) )
       else
          @initials = params[:user].upcase
          @user_name = User.get_full_name(@initials)
          
          @tasks = Task.where( "completed_on IS NULL AND delegated_to = ? AND due_date <= ?", @initials, WorkDate.get(2) ).
             order(:due_date)
          @tasks += Task.where( "completed_on IS NULL AND delegated_to = ? AND (due_date IS NULL OR due_date > ?)", @initials, WorkDate.get(2) ).
             order(created_at: :asc)
          @tasks_done_today = Task.where( "completed_on IS NOT NULL AND (delegated_to = ? OR completed_by = ?) AND completed_on = ?", 
             @initials, @initials, Date.today ).order(:client_name)
       end
    end
    
    def new
       @task = Task.new
       render :layout => false
    end
    
    def create
       format_parameters
       Task.create params[:task]
       
       flash[:notice] = "Task '#{params[:task][:client_name]}' created"
       
       redirect_to(request.referer)
    end
    
    def initial
       task = Task.find(params[:task_id])
       task.update( params[:attribute] => params[:value].upcase )
       
       if params[:attribute] == 'completed_by'
          flash[:notice] = "Task '#{task.client_name}' completed"
          task.update( completed_on: (params[:value].blank? ? nil : Date.today) )
       else
          flash[:notice] = "Task '#{task.client_name}' updated"
       end
       
       
       flash.keep(:notice)
       
       render js: "location.assign('#{request.referer}')"
    end
    
    def edit
      @task = Task.find( params[:id] )
      render :layout => false

    end
    
    def update
       format_parameters
       task = Task.find( params[:id] )
       new_due_date = Date.parse( params[:task][:due_date] ) rescue nil

       if new_due_date.present? and new_due_date <= WorkDate.get(2) and (task.due_date.blank? or new_due_date < task.due_date)
          comment = "IMPORTANT: Task '#{task.client_name}"
          comment += ': ' + task.summary[0,20] unless task.summary.blank?
          comment += "' is now due "
          comment += new_due_date == Date.today ? 'TODAY!' : new_due_date.strftime('%A')
          Comment.create(body: comment)
       end
       
       task.update(params[:task])
       task.completed_on = Date.today unless task.completed_by.blank?
       task.save
       flash[:notice] = "Task '#{task.client_name}' updated"
       
       redirect_to(request.referer)
    end
    
    def destroy
       task = Task.find( params['task_id'] )
       flash[:notice] = "Task '#{task.client_name}' destroyed"
       task.destroy
       
       render js: "location.assign('#{request.referer}')"
    end
    
    def history
       @task_history = Task.where("completed_on IS NOT NULL AND completed_on > ?", Date.today - 30).
          order(completed_on: :desc, completed_by: :asc).all
    end
    
    private
    
    def get_latest_news
       @latest_news = Comment.where('created_at > ?', Time.now - 12.hours).order(created_at: :desc)
    
    end
    
    def format_parameters
       params[:task][:completed_by] = params[:task][:completed_by].upcase rescue nil
       params[:task][:delegated_to] = params[:task][:delegated_to].upcase rescue nil
    end
    
end