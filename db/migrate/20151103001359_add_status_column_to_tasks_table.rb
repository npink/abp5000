class AddStatusColumnToTasksTable < ActiveRecord::Migration
  def change
     change_table :tasks do |t|
        t.string 'status'
     end
  end
end
