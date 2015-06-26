class AddIcedColumnToTasks < ActiveRecord::Migration
  def change
     change_table :tasks do |t|
        t.boolean 'iced', default: false
     end
  end
end
