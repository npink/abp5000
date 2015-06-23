class User < ActiveRecord::Base
   class << self
      
      def fixtures
         User.delete_all
         Task.delete_all
   
         User.create :initials => 'staff', :password => 'staff'
   
         tasks = [
            {client_name: 'Action Property', summary: 'added 7 days ago, no due date', created_at: (Time.now - 7.days) },
            {client_name: 'Barnes Solar', summary: 'added 5 days ago', created_at: (Time.now - 5.days) },
            {client_name: '100 Black Men', summary: 'added 6 days ago', created_at: (Time.now - 6.days) },
            {client_name: 'Ganahl Lumber', summary: 'due today', due_date: Date.today},
            {client_name: 'Solar City', summary: 'done today', delegated_to: 'SS', completed_by: 'NP', completed_on: Date.today},
            {client_name: 'Wesierski & Zurich', summary: 'done today', delegated_to: 'KF', completed_by: 'GP', completed_on: Date.today},
            {client_name: 'Universal Protection', summary: 'done yesterday', delegated_to: 'SP', completed_by: 'SP', completed_on: (Date.today - 1) },
            {client_name: 'OC Sheriffs', summary: 'due tomorrow', due_date: Date.today.next},
            {client_name: 'Geary Pacific', summary: 'added today,due in 3 days', due_date: Date.today + 3},
            {client_name: 'Mammoth Mountain', summary: 'due in 3 days', due_date: Date.today + 3},
            {client_name: 'Placentia Little League', summary: 'due in 5 days', due_date: (Date.today + 5) },
            {client_name: 'Valencia HS', summary: 'due in 4 days', due_date: (Date.today + 4) },
            {client_name: 'Cal State Fullerton', summary: 'added yesterday, due in 3 days', due_date: (Date.today + 3), created_at: (Time.now - 1.days)},
            {client_name: 'City of Anaheim', summary: 'done yesterday', completed_by: 'SS', completed_on: (Date.today - 1) },
            {client_name: 'Casablanca', summary: 'due in 2 days', due_date: (Date.today + 2) },
            
         ]
         tasks.each do |t|
            Task.create t
         end
      end
      
      def reset
         User.delete_all
         Task.delete_all
   
         User.create :initials => 'staff', :password => 'staff'
      end

   end
end