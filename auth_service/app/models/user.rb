class User < ApplicationRecord
  has_secure_password

  # Validations ----
  validates :name, :email, :password, presence:  true
  validates :email, uniqueness: true
end
