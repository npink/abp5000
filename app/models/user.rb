class User < ActiveRecord::Base
   
   class << self
      @@users = {
         'NP' => 'Nick',
         'SS' => 'Sean',
         'PP' => 'Paul',
         'DP' => 'Danny',
         'KF' => 'Nicolas Cage',
         'SP' => 'Steve',
         'JT' => 'Jane',
         'GP' => 'Gail'
      }
      
      def User.users
         @@users
      end
      
      def get_full_name(initials)
         @@users[initials]
      end
      
   end
   
end