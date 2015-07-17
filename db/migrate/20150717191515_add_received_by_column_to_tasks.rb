class AddReceivedByColumnToTasks < ActiveRecord::Migration
   def change
      change_table :tasks do |t|
         t.string 'received_by'
      end
   end
end