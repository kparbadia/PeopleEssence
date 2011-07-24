class AddFbIdForUsers < ActiveRecord::Migration
  def self.up
    add_column(:users, :fb_id, :string)
    add_column(:users, :linkedin_id, :string)
  end

  def self.down
    remove_column(:users, :fb_id)
    remove_column(:users, :linkedin_id)
  end
end
