class TasksController < ApplicationController
   before_filter :create_task_object
   
    def render_queue
       @tasks = Task.queue
    end
    
    def create
        Task.create params[:task]
       
       redirect_to(controller: 'tasks', action: 'render_queue')
    end
    
    private
    
    def create_task_object
       @task = Task.new
    end
end
