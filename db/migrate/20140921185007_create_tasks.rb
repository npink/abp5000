class CreateTasks < ActiveRecord::Migration
   def change
      create_table :tasks do |t|
         t.string    :client_name
         t.string    :summary
         
         t.date      :due_date
         
         t.integer   :duration
         t.string    :equipment_required
         
         t.string    :delegated_to
         t.string    :completed_by
         
         t.timestamps
      end
   end
end