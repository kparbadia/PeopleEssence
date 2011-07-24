class Questionnaire < ActiveRecord::Base
  belongs_to :user
  has_many :answers

  accepts_nested_attributes_for :answers

  after_create :create_default_answers

  def create_default_answers
    Question.find(:all).each() do |q|
      self.answers.create(:user_id => self.user_id, :question_id => q.id, :text => "No", :weight => 0)
    end
  end
end
