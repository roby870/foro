class Answer < ApplicationRecord
  validates :content, presence: true
  validates :user_id, presence: true
  validates :question_id, presence: true

  belongs_to :user
  validates_associated :user
  belongs_to :question
  validates_associated :question

  def self.is_answer_of(answer_id, question_id)
    find_by(question_id: question_id, id: answer_id)
  end

  def self.mark_as_correct(answer_id)
    answer = find_by(id: answer_id)
    answer.checked = true
    answer.save
  end

  def self.create_answer_to_question(content, question_id, user)
    self.create(content: content, question_id: question_id, user_id: user.id)
  end

  def self.get_answers_for_question(question_id)
    where(question_id: question_id)
  end

  def self.answer_exists(id)
    find_by(id: id)
  end

  def self.is_checked(id)
    find_by(id: id, checked: true)
  end

  def self.is_author(user_id, answer_id)
    find_by(id: answer_id, user_id: user_id)
  end

  def self.delete_answer_to_question(answer_id, question_id)
    return nil unless answer = find_by(id: answer_id, question_id: question_id)
    answer.destroy
  end

  def self.question_has_answers(id)
    find_by(question_id: id)
  end

  def self.all_answers_for_question(question_id)
    where(question_id: question_id)
  end

end
