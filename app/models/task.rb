class Task < ActiveRecord::Base
   before_validation :normalize_delegated_to_attribute
   normalize_blank_values
   
   def priority
      if due_date.blank? or due_date > WorkDate.get(2)
         iced? ? 'F' : 'L'
      elsif due_date > Date.today
         'M'
      else
         'H'
      end
   end
   
   def complete?
      completed_on.present? ? true : false
   end
   
   class << self
      
      def active_staff
         staff = Set.new
         tasks = Task.select(:delegated_to, :completed_by).
            where("iced = ? AND (( delegated_to IS NOT NULL AND completed_by IS NULL) OR completed_on = ?)", false, Date.today).
            group(:delegated_to, :completed_by)
            
         tasks.each do |u|
            staff.add(u.delegated_to.upcase) rescue nil
            staff.add(u.completed_by.upcase) rescue nil
         end
         
         staff
      end
      
      def minutes_to_complete_options
         {
            '< 30 mins'    => '30',
            '30 - 60 mins' => '60',
            '1 - 2 hours'  => '2',
            '2 - 4 hours'  => '4',
            '> 4 hours'    => '8'
         }
      end
      
   end
   
   private
   
   def normalize_delegated_to_attribute
      5.times do
         puts 'code not run'
      end
      if complete? and delegated_to.blank?
         puts self
         puts
         puts self
         self[:delegated_to] = self[:completed_by]
      end
   end
   
end