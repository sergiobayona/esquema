# frozen_string_literal: true

class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :address_line_1
      t.string :address_line2
      t.string :state
      t.string :postal_code
      t.string :country, default: "United States of America"
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
