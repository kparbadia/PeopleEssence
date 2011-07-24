class CreateQuestionnaires < ActiveRecord::Migration
  def self.up
    create_table :questionnaires do |t|
      t.integer :user_id
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :questionnaires
  end
end
