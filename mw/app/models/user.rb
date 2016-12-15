require 'bcrypt'
# The User model
class User < ApplicationRecord
  include BCrypt

  validates :name, :password_hash, presence: true
  validates :admin, inclusion: [true, false]
  validates :email, uniqueness: true
  validates :email, presence: true,
                    format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ },
                    uniqueness: { case_sensitive: false }
  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def self.authenticated?(email, password)
    user = User.find_by(email: email)
    return user if user && user.password == password
    false
  end
end
