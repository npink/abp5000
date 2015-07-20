class User < ActiveRecord::Base
   
   class << self
=begin
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
=end
      
      @@users = {

         'SS' => 'The Dude',
         'KF' => 'Nick Cage',
         'DP' => 'Danny',
         'NP' => 'Nick',
         'PP' => 'Paul',
         'GP' => 'Gail',
         'SP' => 'St. Thomas Aquinas',
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