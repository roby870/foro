class User < ApplicationRecord



  validates :username, presence: true, uniqueness: true
  validates :password, presence: true
  validates :screen_name, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :questions
  has_many :answers

  def self.authenticate(u, p)
    self.find_by(username: u, password: p)
  end

  def self.check_token(token)
    user = User.find_by(token: token)
    if user
      if ((Time.zone.now - user.token_created_at).to_i / 60) > 30
        nil
      else
        true
      end
    else
      nil
    end
  end







end
