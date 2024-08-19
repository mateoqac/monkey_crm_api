# frozen_string_literal: true

class CreateBlacklistedTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :blacklisted_tokens do |t|
      t.string :jti, null: false
      t.timestamps
    end
    add_index :blacklisted_tokens, :jti, unique: true
  end
end
