class Question < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :user_id, presence: true

  has_many :answers
  has_many :users, through: :answers
  belongs_to :user
end
