module ApplicationHelper
   
   def initials_field_tag(task_attribute, task)
      text_field_tag(task_attribute, task.send(task_attribute), {
   		'data-task-id' => task.id, 								
   		'data-attribute' => task_attribute,					
   		'maxlength' => 2, 												
   		'size' => 2, 													
   		'class' => 'initials_field'									
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
   						
end