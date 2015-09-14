class RemoveReceivedByColumnFromTasks < ActiveRecord::Migration
  def change
     remove_column :tasks, :received_by
  end
end
