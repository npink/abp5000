class TasksController < ApplicationController
   
   before_filter :create_task_object
   
    def render_queue
       @queue = Task.queue
       @tasks_done_today = Task.completed_today
    end
    
    def create
       format_parameters
       Task.create params[:task]
       
       redirect_to(controller: 'tasks', action: 'render_queue')
    end
    
    def initial
       task = Task.find(params[:task_id])
       task.update( params[:attribute] => params[:value].upcase )
       
       if params[:attribute] == 'completed_by'
          task.update( completed_on: (params[:value].blank? ? nil : Date.today) )
       end
       
       render nothing: true
    end
    
    def edit
      @task = Task.find( params[:id] )
      render :layout => false

    end
    
    def update
       format_parameters
       task = Task.find( params[:id] )
       task.update(params[:task])
       task.completed_on = Date.today unless task.completed_by.blank?
       task.save
       
       redirect_to(controller: 'tasks', action: 'render_queue')
    end
    
    def destroy
       Task.find( params['task_id'] ).destroy
       render nothing: true
    end
    
    def history
       @task_history = Task.history
    end
    
    private
    
    def format_parameters
       params[:task][:completed_by] = params[:task][:completed_by].upcase rescue nil
       params[:task][:delegated_to] = params[:task][:delegated_to].upcase rescue nil
    end
    
    def create_task_object
       @task = Task.new
    end
end