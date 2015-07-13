class TasksController < ApplicationController
   
    def render_queue
       # First find orders that are due within 2 days of today
       @tasks = Task.where("LENGTH(completed_by) <> 2 AND iced = ? AND due_date <= ?", false, WorkDate.get(2) ).
          order(:due_date).all
       # Second, sort remaining orders by creation date, oldest to newest
       @tasks += Task.where("LENGTH(completed_by) <> 2 AND iced = ? AND (due_date IS NULL OR due_date > ?)", false, WorkDate.get(2) ).
          order(created_at: :asc).all
       # Last, get frozen orders
       @tasks += Task.where("completed_on IS NULL AND iced = ?", true)
    end
    
    def create
       format_parameters
       Task.create params[:task]
       
       flash[:notice] = "Task '#{params[:task][:client_name]}' created"
       
       redirect_to(controller: 'tasks', action: 'render_queue')
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
       
       render js: "window.location = '#{url_for(controller: 'tasks', action: 'render_queue')}'"
    end
    
    def edit
      @task = Task.find( params[:id] )
      render :layout => false

    end
    
    def update
       format_parameters
       task = Task.find( params[:id] )
       new_due_date = Date.parse( params[:task][:due_date] ) rescue nil

       if !new_due_date.blank? and (task.due_date.blank? or new_due_date < task.due_date)
          Comment.create(
          body: "UPDATE: Task '#{task.client_name}' now due on #{new_due_date.strftime("%a, %m-%d")}"
          )
       end
       
       task.update(params[:task])
       task.completed_on = Date.today unless task.completed_by.blank?
       task.save
       flash[:notice] = "Task '#{task.client_name}' updated"
       
       redirect_to(controller: 'tasks', action: 'render_queue')
    end
    
    def destroy
       task = Task.find( params['task_id'] )
       flash[:notice] = "Task '#{task.client_name}' destroyed"
       task.destroy
       
       render nothing: true
    end
    
    def history
       @task_history = Task.where("completed_on IS NOT NULL AND completed_on > ?", Date.today - 30).order(completed_on: :desc).all
    end
    
    private
    
    def format_parameters
       params[:task][:completed_by] = params[:task][:completed_by].upcase rescue nil
       params[:task][:delegated_to] = params[:task][:delegated_to].upcase rescue nil
    end
    
end