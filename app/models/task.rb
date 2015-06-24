class Task < ActiveRecord::Base
   
   def priority
      if due_date.blank? or due_date > WorkDate.get(2)
         'Low'
      elsif due_date == Date.today + 1 or due_date == WorkDate.get(2)
         'Medium'
      else
         'High'
      end
   end
   
   class << self
      
      def minutes_to_complete_options
         {
            '< 30 mins'    => 30,
            '30 - 60 mins' => 60,
            '1 - 2 hours'  => 2,
            '2 - 4 hours'  => 4,
            '> 4 hours'    => 8
         }
      end
      
      # Find incompleted orders and sort by due date and creation date
      def queue
         # First find orders that are due within 2 days of today
         tasks = Task.where("completed_on IS NULL AND due_date <= ?", WorkDate.get(2) ).
            order(:due_date).all
         # Second, sort remaining orders by creation date, oldest to newest
         tasks += Task.where("completed_on IS NULL AND (due_date IS NULL OR due_date > ?)", WorkDate.get(2) ).
            order(created_at: :asc).all
      end
      
      def completed_today
         Task.where("completed_on = ?", Date.today).all
      end
      
   end
   
end