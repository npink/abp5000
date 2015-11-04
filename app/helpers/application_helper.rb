module ApplicationHelper
   
   def render_priority(priority)
      
      if priority == 'L'
         color = 'green'
      elsif priority == 'M'
         color = 'orange'
      elsif priority == 'H'
         color = 'red'
      elsif priority == 'F'
         color = 'blue'
      else
         color = ''
      end
      
      color.blank? ? priority : image_tag("#{color}_circle.png", height: '20', width: '20')
   end	
   
   def render_summary(summary)
      begin
         lines = summary.lines
         text = lines[0][0,30]
         text += '...' if lines[0].size > 30 or lines.size > 1
         text
      rescue
         summary
      end
   end
   
   def render_status_updater(task)
      content_tag(:span, :class => 'status_updater') do
         
         if task.status == 'P'
            concat image_tag('pending_stamp.png', :class => 'status_stamp')
         elsif task.status == 'A'
            concat image_tag('approved_stamp.png', :class => 'status_stamp')
         end
         
         concat select_tag :status, options_for_select(Task.status_options, task.status), :class => "status_options hidden", 'data-task-id' => task.id
      end
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
   
   def render_task_initials_field(task, task_attribute)
      initials = task.send(task_attribute)
      if User.users.keys.include? initials
         image_tag("avatars/#{initials.downcase}.jpeg", class: 'headshot img-circle')
      else
         text_field_tag(task_attribute, initials, {
      		'data-task-id' => task.id, 								
      		'data-attribute' => task_attribute,					
      		'maxlength' => 2, 												
      		'size' => 2, 													
      		'class' => 'initials_field initials_updater'									
      	})
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