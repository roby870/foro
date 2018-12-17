class Question < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :user_id, presence: true

  has_many :answers
  has_one :answer
  has_many :users, through: :answers
  belongs_to :user
  validates_associated :user

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

  def self.mark_as_resolved(id, answer_id)
    question = find_by(id: id)
    question.status = true
    question.answer_id=answer_id
    question.save
  end

  def self.is_answered(id)
    find_by(id: id, status: true)
  end

  def self.delete_question(id)
      question = find_by(id: id)
      question.destroy
  end

  def self.exists(id)
    find_by(id: id)
  end

  def self.fifty_latest
    limit(50).left_outer_joins(:answers).select(:id, :title, :description, :status, 'count(answers.id) as answers_count').order(created_at: :desc).group(:id)
  end

  def self.fifty_pending
    limit(50).left_outer_joins(:answers).select(:id, :title, :description, :status, 'count(answers.id) as answers_count').order(status: :asc, created_at: :desc).group(:id)
  end

  def self.fifty_needing_help
    limit(50).left_outer_joins(:answers).select(:id, :title, :description, :status, 'count(answers.id) as answers_count').where(status: false).group(:id).order("count(answers.id) ASC")
  end

end
