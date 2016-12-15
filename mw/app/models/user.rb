require 'bcrypt'

class User < ApplicationRecord
  include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def self.authenticated?(email, password)
    user = User.find_by_email(email)
    return user if user && user.password == password
    false
  end
end
