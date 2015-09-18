class Task < ActiveRecord::Base
   before_validation :normalize_delegated_to_attribute
   before_save :unfreeze_completed_tasks
   
   normalize_blank_values
   
   def iced?
      iced ? true : false
   end
   
   def priority
      if due_date == nil
         iced? ? 'F' : 'L'
      else
         if due_date == Date.today
            'H'
         elsif duration == '8' and due_date < WorkDate.get(6)
            'M'
         elsif due_date < WorkDate.get(3)
            'M'
         else
            'L'
         end
      end
   end
   
   def complete?
      completed_on.present? ? true : false
   end
   
   class << self
      
      def active_staff
         staff = Set.new
         tasks = Task.select(:delegated_to, :completed_by).
            where("(delegated_to IS NOT NULL AND completed_by IS NULL) OR completed_on = ?", Date.today).
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
      if complete? and delegated_to.blank?
         self[:delegated_to] = self[:completed_by]
      end
   end
   
   def unfreeze_completed_tasks
      self[:iced] = false if self[:completed_by].present?
      true
   end
   
end