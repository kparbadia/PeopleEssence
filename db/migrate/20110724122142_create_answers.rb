class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.integer :questionnaire_id
      t.integer :question_id
      t.integer :user_id
      t.string :text
      t.integer :weight

      t.timestamps
    end
  end

  def self.down
    drop_table :answers
  end
end
