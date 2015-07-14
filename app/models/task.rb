class Task < ActiveRecord::Base
   before_validation :normalize_delegated_to_attribute
   normalize_blank_values
   
   def priority
      if iced?
         'F'
      elsif due_date.blank? or due_date > WorkDate.get(2)
         'L'
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