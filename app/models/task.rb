class Task < ActiveRecord::Base
   
   def priority
      if due_date.blank? or due_date > (Date.today + 1)
         'L'
      elsif due_date == Date.today + 1
         'M'
      else
         'H'
      end
   end
   
   class << self
      
      def minutes_to_complete_options
         {
            '15 minutes' => 15,
            '30 minutes' => 30,
            '1 hour'     => 1,
            '2 hours'    => 2,
            '3 hours'    => 3,
            '4 hours'    => 4,
            '> 4 hours'    => '> 4'
         }
      end
      
      # Find incompleted orders and sort by due date and creation date

      def queue
         # First find orders that are due within 2 days of today
         tasks = Task.where("completed_by IS NULL AND due_date < ?", Date.today + 2).
            order(:due_date).all
         # Next find orders with no due date and sort oldest to newest
         tasks += Task.where("completed_by IS NULL AND due_date IS NULL").all
         # Last find orders due later than 2 days days from today
         tasks += Task.where("completed_by IS NULL AND due_date > ?", Date.today + 2).all
         tasks
      end
      
   end
   
end
