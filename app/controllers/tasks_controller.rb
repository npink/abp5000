class TasksController < ApplicationController
   
     before_filter :get_latest_news
     
     def dashboard
        @tasks_due_soon = Task.where("completed_by IS NULL AND due_date <= ?", WorkDate.get(2) ).
           order(:due_date)
        @tasks_older_than_a_week = Task.where("completed_by IS NULL AND iced = ? AND created_at < ? AND (due_date IS NULL OR due_date > ?)", 
           false, Time.now - 6.days, WorkDate.get(2) ).
           order(created_at: :asc)
        @tasks = @tasks_due_soon + @tasks_older_than_a_week
     end
    
    # Render all tasks that incomplete and undelegated
    def queue
       
       if params[:for].blank?
          # First find orders that are due within 2 days of today
          @tasks = Task.where("completed_by IS NULL AND due_date <= ? AND delegated_to IS NULL", WorkDate.get(2) ).
             order(:due_date)
          # Second, sort remaining orders by creation date, oldest to newest
          @tasks += Task.where("completed_by IS NULL AND iced = ? AND (due_date IS NULL OR due_date > ?) AND delegated_to IS NULL", 
             false, WorkDate.get(2) ).
             order(created_at: :asc)
          # Last, get frozen orders not due within 2 days
          @tasks += Task.where( "completed_by IS NULL AND delegated_to IS NULL AND iced = ? AND (due_date IS NULL OR due_date > ?)", true, WorkDate.get(2) ).
             order(created_at: :desc)
       else
          @initials = params[:for].upcase
          @user_name = User.get_full_name(@initials)
          
          @tasks = Task.where( "completed_by IS NULL AND delegated_to = ? AND due_date <= ?", @initials, WorkDate.get(2) ).
             order(:due_date)
          @tasks += Task.where( "completed_by IS NULL AND delegated_to = ? AND (due_date IS NULL OR due_date > ?) AND iced = ?", @initials, WorkDate.get(2), false ).
             order(created_at: :asc)
          @tasks += Task.where( "completed_by IS NULL AND delegated_to = ? AND iced = ? AND (due_date IS NULL OR due_date > ?)", @initials, true, WorkDate.get(2) ).
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
       
       @news_update = create_news_update_for_urgent_tasks?
       
       @task = Task.create params[:task]
       
       create_news_update_for_urgent_tasks if @news_update
       
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
    
    def edit
      @task = Task.find( params[:id] )
      render :layout => false

    end
    
    def update
       format_parameters
       @task = Task.find( params[:id] )
       @news_update = create_news_update_for_urgent_tasks?
       @task.update(params[:task])
       create_news_update_for_urgent_tasks if @news_update
       
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
    
    def create_news_update_for_urgent_tasks?
       @task = Task.new unless @task
       @new_due_date = Date.parse( params[:task][:due_date] ) rescue nil

       if @new_due_date.present? and @new_due_date <= WorkDate.get(2) and (@task.due_date.blank? or @new_due_date < @task.due_date)
          true
       else
          false
       end
       
    end
    
    def create_news_update_for_urgent_tasks
       comment = "IMPORTANT: Task '#{@task.client_name}"
       comment += ' > ' + @task.summary[0,20] unless @task.summary.blank?
       comment += "' is now due "
       comment += @new_due_date == Date.today ? 'TODAY!' : @new_due_date.strftime('%A')
       Comment.create(body: comment)
    end
    
    def get_latest_news
       @latest_news = Comment.where('created_at > ?', Time.now - 24.hours).order(created_at: :desc)
    
    end
    
    def format_parameters
       params[:task][:completed_by] = params[:task][:completed_by].upcase rescue nil
       params[:task][:delegated_to] = params[:task][:delegated_to].upcase rescue nil
    end
    
end