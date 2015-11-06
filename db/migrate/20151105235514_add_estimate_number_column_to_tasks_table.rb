class AddEstimateNumberColumnToTasksTable < ActiveRecord::Migration
  
  def change
     change_table :tasks do |t|
        t.string 'estimate_number'
     end
  end
end
