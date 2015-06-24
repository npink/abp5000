module ApplicationHelper
   
   def initials_field_tag(task_attribute, task)
      text_field_tag(task_attribute, task.send(task_attribute), {
   		'data-task-id' => task.id, 								
   		'data-attribute' => task_attribute,					
   		'maxlength' => 2, 												
   		'size' => 2, 													
   		'class' => 'initials_field initials_updater'									
   	})
   end		
   
   def render_due_date(date)
      return if date.blank?
      
      if date == Date.today
         "Today"
      elsif date == Date.today + 1
         "Tomorrow"
      else
         date.strftime("%a, %m-%d")
      end
   end				
   
   def render_headshot(task)
      puts task.delegated_to
      if ['DP', 'NP', 'KF', 'SS'].include? task.delegated_to
         image_tag("headshots/#{task.delegated_to.downcase}.jpeg") 
      end
   end
   						
end