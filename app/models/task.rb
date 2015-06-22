class Task < ActiveRecord::Base
   
   class << self
      def minutes_to_complete_options
         {
            '15 minutes' => 15,
            '30 minutes' => 30,
            '1 hour'     => 60,
            '2 hours'    => 120,
            '3 hours'    => 180,
            '4 hours'    => 240,
            '> 4 hours'    => 360
         }
      end
   end
end
