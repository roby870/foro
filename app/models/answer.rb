class Answer < ApplicationRecord
  validates :content, presence: true
  validates :screen_name, presence: true

  belongs_to :user
  belongs_to :question
end
