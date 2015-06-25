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
   
   def render_headshot(initials)
      if ['DP', 'NP', 'KF', 'SS', 'SP', 'PP', 'GP'].include? initials
         image_tag("headshots/#{initials.downcase}.jpeg")
      end
   end
   
   def render_duration(duration)
      html = ""
      
      if duration == '30'
         image_tag('star_icon.png')
      elsif duration == '60'
         2.times do
            html += image_tag('star_icon.png')
         end
         raw html
      elsif duration == '2'
         3.times do
            html += image_tag('star_icon.png')
         end
         raw html
      elsif duration == '4'
         4.times do
            html += image_tag('star_icon.png')
         end
         raw html
      elsif duration == '8'
         image_tag("godzilla.gif")
      else
         duration
      end
   end
   						
end