namespace :app do
   
desc "seed"
task 'seed' => :environment do
   User.reset
end

end