class CreateUserDetails < ActiveRecord::Migration
  def self.up
    create_table :user_details do |t|
      t.string :linkedin_attribute
      t.string :linkedin_value
      t.string :category
      t.string :reference
      t.integer :user_id
      t.integer :weight

      t.timestamps
    end
  end

  def self.down
    drop_table :user_details
  end
end
