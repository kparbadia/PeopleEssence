class CreateJobDetails < ActiveRecord::Migration
  def self.up
    create_table :job_details do |t|
      t.integer :job_id
      t.string :category
      t.string :reference
      t.integer :weight
      t.string :answer
      t.integer :answer_weight

      t.timestamps
    end
  end

  def self.down
    drop_table :job_details
  end
end
