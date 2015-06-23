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
   										
end