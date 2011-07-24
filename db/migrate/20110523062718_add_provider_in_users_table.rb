class AddProviderInUsersTable < ActiveRecord::Migration
  def self.up
      remove_column(:users, :fb_id)
      remove_column(:users, :linkedin_id)

      add_column(:users, :provider, :string)
      add_column(:users, :provider_id, :string)
      add_column(:users, :user_name, :string)
  end

  def self.down
     add_column(:users, :fb_id, :string)
     add_column(:users, :linkedin_id, :string)

     remove_column(:users, :provider)
     remove_column(:users, :provider_id)
     remove_column(:users, :user_name)
  end
end
