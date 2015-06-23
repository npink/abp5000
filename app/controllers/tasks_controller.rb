class TasksController < ApplicationController
   before_filter :create_task_object
   
    def render_queue
       @queue = Task.queue
       @tasks_done_today = Task.completed_today
    end
    
    def create
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
    
    def destroy
       Task.find( params['task_id'] ).destroy
       render nothing: true
    end
    
    private
    
    def create_task_object
       @task = Task.new
    end
end