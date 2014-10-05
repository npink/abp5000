class CreateOrders < ActiveRecord::Migration
   def change
      create_table :orders do |t|
         t.string    :client_name
         t.string    :summary
         
         t.date      :production_date
         t.date      :due_date
         
         t.integer   :minutes_to_complete
         t.string    :proof
         t.string    :delivery_method
         t.string    :user_id
         
         t.timestamps
      end
   end
end