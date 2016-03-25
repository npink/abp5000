class ChangeTaskSummaryToTextType < ActiveRecord::Migration
  def change
     change_column :tasks, :summary, :text
  end
end
