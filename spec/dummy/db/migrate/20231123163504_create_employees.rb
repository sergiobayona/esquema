class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :email
      t.date :birth_date
      t.boolean :active, default: false
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
    add_index :employees, :email
  end
end
