# frozen_string_literal: true

class CreateCustomers < ActiveRecord::Migration[7.2]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :surname
      t.string :photo
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.references :last_modified_by, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
