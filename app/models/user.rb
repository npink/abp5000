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
         'JT' => 'Jane',
         'AK' => 'Allison'
         
      }
      
      @@hours_worked = {
         'SS' => 18,
         'NP' => 40,
         'DP' => 18,
         'KF' => 18,
         'JT' => 40,
         'GP' => 40,
         'PP' => 40,
         'SP' => 40
      }
      
      def User.users
         @@users
      end
      
      def get_full_name(initials)
         @@users[initials]
      end
      
      def hours_worked(initials)
         @@hours_worked[initials]
      end
      
   end
   
end