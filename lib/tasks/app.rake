namespace :app do
   
desc "seed"
task 'seed' => :environment do
   User.create :initials => 'np', :password => 'foobar'
end

end