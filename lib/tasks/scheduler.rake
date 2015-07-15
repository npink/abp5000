namespace :scheduler do

   task :clean_database => :environment do
      # Destroy all tasks and comments older than 30 days to keep DB small
     Task.where('completed_on < ?', Date.today - 30.days).destroy_all
     Comment.where('created_at < ?', Time.now - 30.days).destroy_all
   end
   
end