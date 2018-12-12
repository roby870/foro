require 'bcrypt'

class User < ApplicationRecord

  include BCrypt

  validates :username, presence: true, uniqueness: true
  validates :password_hash, presence: true
  validates :screen_name, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :questions
  has_many :answers

  def self.authenticate(u, p)
    if user = self.find_by(username: u)
      if (user.password == p)
        user
      else
        false
      end
    else
      false
    end
  end

  def self.check_token(token)
    user = User.find_by(token: token)
    if user
      if ((Time.zone.now - user.token_created_at).to_i / 60) > 30
        false
      else
        true
      end
    else
      false
    end
  end

  def self.create_user(username, password, screen_name, email)
    User.create(username: username,password_hash: Password.create(password),screen_name: screen_name,email: email)
  end

  def password
    Password.new(self.password_hash)
  end




end
