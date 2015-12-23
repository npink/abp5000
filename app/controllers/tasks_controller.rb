class TasksController < ApplicationController
   
     before_filter :get_latest_news
     
     def to_do
        @tasks_due_soon = Task.where("completed_by IS NULL AND ((due_date <= ? AND duration <> '8') OR (duration = '8' AND due_date < ?))", WorkDate.get(2), WorkDate.get(6) ).
           order(:due_date)
        @tasks_due_later = Task.where("completed_by IS NULL AND iced = ? AND (due_date IS NULL OR (due_date > ? AND duration <> '8') OR (due_date >= ? AND duration = '8'))", 
           false, WorkDate.get(2), WorkDate.get(6) ).
           order(created_at: :asc)
        @tasks_frozen_and_not_due_soon = Task.where( "completed_by IS NULL AND iced = ? AND (due_date IS NULL OR (due_date > ? AND duration <> '8') OR (due_date >= ? AND duration = '8'))", true, WorkDate.get(2), WorkDate.get(6) ).
              order(created_at: :desc)
        @tasks = @tasks_due_soon + @tasks_due_later + @tasks_frozen_and_not_due_soon
        
        @work_hours_left = 0
       Task.where("completed_by IS NULL AND iced = ?", false).each do |t|
          case t.duration
          when '30'
             @work_hours_left += 0.25
          when '60'
             @work_hours_left += 0.75
          when '2'
             @work_hours_left += 1.5
          when '4'
             @work_hours_left += 3
          when '8'
             @work_hours_left += 6
          end
       end
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
          
          if @tasks.empty?
             @suggested_task = Task.where("duration = '30' AND delegated_to IS NULL AND iced = ?", false)
             unless @suggested_task.empty?
                @suggested_task = @suggested_task[rand(@suggested_task.size)]
             else
                @suggested_task = nil
             end 
          end
          
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
    
    def points
       @points = Hash.new(0)
       Task.where('completed_by IS NOT NULL').each do |t|
          case t.duration
          when '30'
             task_points = 10
          when '60'
             task_points = 20
          when '2'
             task_points = 50
          when '4'
             task_points = 100
          when '8'
             task_points = 200
          end
          if t.delegated_to == t.completed_by
             @points[t.delegated_to] += task_points
          else
             @points[t.delegated_to] += (task_points / 2)
             @points[t.completed_by] += (task_points / 2)
          end
       end
       @points = Hash[ @points.sort_by{ |k, v| v }.reverse ]
    end
    
    def skiurf_report
       
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
    
    def received_by
       task = Task.find(params[:task_id])
       task.update( :received_by => params[:received_by] )
       flash[:notice] = "Task '#{task.client_name}' updated"
       flash.keep(:notice)
       
       render js: "location.assign('#{request.referer}')"
    end
    
    private
    
    def get_latest_news
       @latest_news = Comment.where('created_at > ?', Time.now - 24.hours).order(created_at: :desc)
    
    end
    
    def format_parameters
       params[:task][:completed_by] = params[:task][:completed_by].upcase rescue nil
       params[:task][:delegated_to] = params[:task][:delegated_to].upcase rescue nil
    end
    
end