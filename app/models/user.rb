class User < ActiveRecord::Base
   
   class << self
      @@users = {

         'SS' => 'Sean',
         'KF' => 'Konner',
         'DP' => 'Danny',
         'NP' => 'Nick',
         'PP' => 'Paul',
         'GP' => 'Gail',
         'SP' => 'Steve',
         'JT' => 'Jane'
         
      }
      
      def User.users
         @@users
      end
      
      def get_full_name(initials)
         @@users[initials]
      end
      
   end
   
end