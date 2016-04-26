class AddActiveColumnToTasks < ActiveRecord::Migration
  def change
     change_table :tasks do |t|
         t.boolean 'active', default: false
     end
  end
end
