class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.datetime :completed_at

      t.timestamps
    end
    add_index :tasks, :user_id
  end
end
