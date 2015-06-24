class WorkDate < Date
   
   class << self
      
      def get(number_of_days)
         target_date = Date.today
      
         number_of_days.times do
            target_date = target_date.next
            target_date = target_date + 2 if target_date.saturday?
            target_date = target_date + 1 if target_date.sunday?
         end
      
         return target_date
      end
   
   end
   
end