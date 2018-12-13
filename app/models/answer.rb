class Answer < ApplicationRecord
  validates :content, presence: true
  validates :user_id, presence: true
  validates :question_id, presence: true

  belongs_to :user
  belongs_to :question

  def self.is_answer_of(answer_id, question_id)
    find_by(question_id: question_id, id: answer_id)
  end

  def self.mark_as_correct(answer_id)
    answer = find_by(id: answer_id)
    answer.ckeked = true
  end

  def self.create_answer_to_question(content, question_id, user)
    self.create(content: content, question_id: question_id, user_id: user.id)
  end

end
