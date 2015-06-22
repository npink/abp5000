namespace :app do
   
desc "seed"
task 'seed' => :environment do
   User.delete_all
   Task.delete_all
   
   User.create :initials => 'np', :password => 'foobar'
   
   tasks = [
      {client_name: 'a', summary: 'added 7 days ago', created_at: (Time.now - 7.days) },
      {client_name: 'b', summary: 'added 5 days ago', created_at: (Time.now - 5.days) },
      {client_name: 'c', summary: 'due today', due_date: Date.today},
      {client_name: 'd', summary: 'done already', completed_by: 'np'},
      {client_name: 'e', summary: 'due tomorrow', due_date: Date.today.next},
      {client_name: 'f', summary: 'due in 2 days', due_date: Date.today + 2},
      {client_name: 'g', summary: 'due in 3 days', due_date: Date.today + 3},
      {client_name: 'h', summary: 'due in 5 days', due_date: (Date.today + 5) }
      
   ]
   tasks.each do |t|
      Task.create t
   end
end

end