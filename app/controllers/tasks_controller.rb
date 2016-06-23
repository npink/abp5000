class TasksController < ApplicationController
   
     before_filter :get_latest_news
     
     def to_do   
        @unfinished = Task.where("completed_by IS NULL AND iced = ?", false)
        @prioritized = []
        # do very soon, due today, tomorrow or past due
        @prioritized[0] = @unfinished.where('due_date <= ?', Date.today).order(created_at: :asc)
        @prioritized[0] += @unfinished.where('due_date = ?', WorkDate.get(1) ).
           order(created_at: :asc)
        # do soon
        due_in_next_few_days = @unfinished.where('due_date = ? OR due_date = ?', WorkDate.get(2), WorkDate.get(3) ).
           order(due_date: :asc)
        
        older_than_a_week_no_due_date = @unfinished.where('created_at <= ? AND due_date IS NULL', Date.today - 6 ).
           order(created_at: :asc)
           
        @prioritized[1] = interleave(due_in_next_few_days, older_than_a_week_no_due_date) 
        
        # low priority, remaining tasks sorted from oldest to newest
        @prioritized[2] = @unfinished.where("(created_at > ? AND due_date IS NULL) OR due_date > ?", Date.today - 6, WorkDate.get(3) ).
           order(created_at: :asc)
        # frozen priority
        @prioritized[3] = Task.where("completed_by IS NULL and iced = ?", true).order(created_at: :asc)
        @tasks_to_do = 0
        
        @prioritized.each do |p|
           @tasks_to_do += p.size
        end
        
  		  @priorities = [
  			['high', 'Do First'],
  			['medium', 'Do Second'],
         ['low', 'Do Third'],
         ['frozen', 'Frozen']
  		]
         
      @high_hours = Task.count_hours(@prioritized[0])
      @medium_hours = Task.count_hours(@prioritized[1]) + @high_hours
      @low_hours = Task.count_hours(@prioritized[2]) + @medium_hours
      @frozen_hours = Task.count_hours(@prioritized[3])
    end
    
    def history
       @task_history = Task.where("completed_by IS NOT NULL AND completed_on > ?", Date.today - 30).
          order(completed_on: :desc, delegated_to: :asc).all
    end
    
    def all
       @tasks = Task.order('LOWER(client_name)').all
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
          task.update( 'active' =>  true )
          flash[:notice] = "Task '#{task.client_name}' delegated to #{User.get_full_name(task.delegated_to)}"
       end
       
       
       flash.keep(:notice)
       
       render js: "location.assign('#{request.referer}')"
    end
    
    def update_status
       task = Task.find(params[:task_id])
       task.update( 'status' =>  params[:task_status] )
       
       
       flash[:notice] = "Task '#{task.client_name}' status changed"
       render js: "location.assign('#{request.referer}')"
    end
    
    def update_active
       task = Task.find(params[:task_id])
       task.update( 'active' =>  (params[:task_active] == 'true' ? true : false)  )
       
       render :nothing => true
    end
    
    def edit
      @task = Task.find( params[:id] )
      render :layout => false

    end
    
    def update
       format_parameters
       @task = Task.find( params[:id] )
       @task.update(params[:task])
       
       if @task.completed_by.blank?
          @task.completed_on = nil
       else
          @task.completed_on = Date.today 
       end
       
       @task.save
       flash[:notice] = "Task '#{@task.client_name}' updated"
       redirect_to(request.referer)
    end
    
    def destroy
       task = Task.find( params['task_id'] )
       flash[:notice] = "Task '#{task.client_name}' destroyed"
       task.destroy
       
       render js: "location.assign('#{request.referer}')"
    end
    
    private
    
    def interleave(*args)
      raise 'No arrays to interleave' if args.empty?
      max_length = args.map(&:size).max
      output = []
      max_length.times do |i|
        args.each do |elem|
          output << elem[i] if i < elem.length
        end
      end
      output
    end
    
    def get_latest_news
       @latest_news = Comment.where('created_at > ?', Time.now - 24.hours).order(created_at: :desc)
    
    end
    
    def format_parameters
       params[:task][:completed_by] = params[:task][:completed_by].upcase rescue nil
       params[:task][:delegated_to] = params[:task][:delegated_to].upcase rescue nil
    end
    
end