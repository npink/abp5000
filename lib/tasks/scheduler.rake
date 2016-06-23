namespace :scheduler do

   task :clean_database => :environment do
      # Destroy all tasks and comments older than 30 days to keep DB small
     Task.where('completed_on < ?', Date.today - 30.days).destroy_all
     Comment.where('created_at < ?', Time.now - 30.days).destroy_all
     
     # Unfreeze any incomplete tasks that are due within 3 days
     Task.where("completed_by IS NULL AND iced = ? AND due_date <= ?", true, WorkDate.get(3) ).each do |t|
        t.iced = false
        t.save
     end
     
     # Deactivate all tasks
     Task.update_all('active' => false)
   end
   
end