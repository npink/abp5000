class CreateCommentsTable < ActiveRecord::Migration
  def change
    create_table :comments do |t|
       t.string :body
       t.string :username
       t.timestamps
    end
  end
end
