class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  belongs_to :questionnaire

  before_validation :set_weight

  def set_weight
    ans_option = Question.answer_options.detect(){|option| option[:label] == self.text}
    self.weight = ans_option[:weight]
  end
end
