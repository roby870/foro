class Question < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :user_id, presence: true

  has_many :answers
  has_many :users, through: :answers
  belongs_to :user

  def self.create_question(title, description, user_id)
    self.create(title: title, description: description, user_id: user_id)
  end

  def self.check_user_has_question(user, question_id)
    find_by(id: question_id, user_id: user.id)
  end

  def self.update_title(title, question)
    question.title=title
    question.save
  end

  def self.update_description(description, question)
    question.description=description
    question.save
  end

end
