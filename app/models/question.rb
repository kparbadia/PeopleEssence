class Question < ActiveRecord::Base
  has_many :answers

  def self.answer_options
    [{:weight => 0, :label => "No"}, {:weight => 1, :label => "Sometimes"}, {:weight => 2, :label => "Yes"}]
  end
end
