
require 'bcrypt'

class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true

  # Encrypt the password before saving the user
  before_save :encrypt_password

  def validate_password(submitted_password, encrypted_password)
    BCrypt::Password.new(encrypted_password) == submitted_password
  end

  private

  def encrypt_password
    self.password = BCrypt::Password.create(password)
  end
end
