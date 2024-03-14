class User < ApplicationRecord
  has_secure_password
  # With has_secure_password, your model gains two virtual attributes: password and password_confirmation. These attributes are used to set and confirm passwords during user registration and password updates.
  # When you set the password attribute on a new or existing model instance, has_secure_password automatically encrypts the password and stores the encrypted version in the password_digest column in the database. It uses bcrypt, a secure hashing algorithm, for encryption.
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end
