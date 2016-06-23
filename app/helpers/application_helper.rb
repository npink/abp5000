module ApplicationHelper
   
   def render_summary(summary)
      begin
         lines = summary.lines
         text = lines[0][0,50]
         text += '...' if lines[0].size > 50 or lines.size > 1
         text
      rescue
         summary
      end
   end
   
   def render_status_updater(task)
      content_tag(:span, :class => 'status_updater') do
         
         if task.status == 'P'
            concat image_tag('submitted_for_review.png', :class => 'status_stamp')
         elsif task.status == 'A'
            concat image_tag('approved_stamp.png', :class => 'status_stamp')
         end
         
         concat select_tag :status, options_for_select(Task.status_options, task.status), :class => "status_options none", 'data-task-id' => task.id
      end
   end
   
   def render_due_date(date)
      return if date.blank?
      
      if date == Date.today
         "Today"
      elsif date == Date.today + 1
         "Tomorrow"
      elsif date < Date.today + 7 and date > Date.today
         date.strftime("%A")
      else
         date.strftime("%a, %m-%d")
      end
   end
   
   def render_task_responsible(task)
      initials = task.delegated_to
      html = ""
      html += image_tag("avatars/#{initials.downcase}.jpeg", class: 'img-circle') unless initials.blank?
      html += text_field_tag('delegated_to', initials, {
   		'data-task-id' => task.id, 								
   		'data-attribute' => 'delegated_to',					
   		'maxlength' => 2, 												
   		'size' => 2, 													
   		'class' => 'initials_field initials_updater delegated_to none'									
   	})
      raw html
   end
   
   def render_task_completed_by(task)
      text_field_tag('completed_by', '', {
         		'data-task-id' => task.id, 								
         		'data-attribute' => 'completed_by',					
         		'maxlength' => 2, 												
         		'size' => 2, 													
         		'class' => 'initials_field initials_updater completed_by hidden'									
      })
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
   
   def render_gears(t)
		html = image_tag("spinning_gear.gif", :class => "spinning_gear gear #{'none' unless t.active}", 'data-task-id' => t.id, 'data-task-active' => false)
		html += image_tag("static_gear.gif", :class => "static_gear gear #{t.active ? 'none' : 'hidden'}", 'data-task-id' => t.id, 'data-task-active' => true)
      raw html
   end
   						
end