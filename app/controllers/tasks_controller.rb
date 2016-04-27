class TasksController < ApplicationController
   
     before_filter :get_latest_news
     
     def to_do   
        @unfinished = Task.where("completed_by IS NULL AND iced = ?", false)
        @prioritized = []
        # high priority, due today and past due
        @prioritized[0] = @unfinished.where('due_date <= ?', Date.today).order(created_at: :asc)
        # medium priority
        # due tomorrow
        @prioritized[1] = @unfinished.where('due_date = ?', WorkDate.get(1) ).
           order(created_at: :asc)
        # one week or more older
        @prioritized[1] += @unfinished.where('created_at <= ? AND (due_date > ? OR due_date IS NULL)', Date.today - 6, WorkDate.get(1) ).
           order(created_at: :asc)
        # due the day after tomorrow, but not more than one week old
        @prioritized[1] += @unfinished.where('due_date = ? AND created_at > ?', WorkDate.get(2), Date.today - 6 ).
           order(created_at: :asc)
        # monster tasks due within the next week
        @prioritized[1] += @unfinished.where("duration = '8' AND due_date > ? AND due_date < ? AND created_at > ?", WorkDate.get(2), WorkDate.get(6), Date.today - 6)
        # low priority, remaining tasks sorted from oldest to newest
        @prioritized[2] = @unfinished.where("created_at > ? AND (((due_date IS NULL OR due_date > ?) AND duration <> '8') OR (duration = '8' AND (due_date IS NULL OR due_date >= ?) ) )", Date.today - 6, WorkDate.get(2), WorkDate.get(6) ).
           order(created_at: :asc)
        # frozen priority
        @prioritized[3] = Task.where("completed_by IS NULL and iced = ?", true).order(created_at: :asc)
  		  @priorities = [
  			'High',
  			'Medium',
         'Low',
         'Frozen'
  		]
         
      @high_hours = Task.count_hours(@prioritized[0])
      @medium_hours = Task.count_hours(@prioritized[1]) + @high_hours
      @low_hours = Task.count_hours(@prioritized[2]) + @medium_hours
      @frozen_hours = Task.count_hours(@prioritized[3])
    end
    
    # Render all tasks for a certain person
    def queue
          @initials = params[:for].upcase
          @user_name = User.get_full_name(@initials)
          
          @tasks = Task.where( "completed_by IS NULL AND delegated_to = ? AND ((due_date <= ? AND duration <> '8') OR (duration = '8' AND due_date < ?))", @initials, WorkDate.get(2), WorkDate.get(6) ).
             order(:due_date)
          @tasks += Task.where( "completed_by IS NULL AND delegated_to = ? AND iced = ? AND (due_date IS NULL OR (due_date > ? AND duration <> '8') OR (due_date >= ? AND duration = '8'))", @initials, false, WorkDate.get(2), WorkDate.get(6) ).
             order(created_at: :asc)
          @tasks += Task.where( "completed_by IS NULL AND delegated_to = ? AND iced = ? AND (due_date IS NULL OR (due_date > ? AND duration <> '8') OR (due_date >= ? AND duration = '8'))", @initials, true, WorkDate.get(2), WorkDate.get(6) ).
             order(created_at: :desc)
          
          @tasks_done_today = Task.where( "completed_by IS NOT NULL AND (delegated_to = ? OR completed_by = ?) AND completed_on = ?", 
             @initials, @initials, Date.today ).order(:client_name)
       
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
    
    def get_latest_news
       @latest_news = Comment.where('created_at > ?', Time.now - 48.hours).order(created_at: :desc)
    
    end
    
    def format_parameters
       params[:task][:completed_by] = params[:task][:completed_by].upcase rescue nil
       params[:task][:delegated_to] = params[:task][:delegated_to].upcase rescue nil
    end
    
end