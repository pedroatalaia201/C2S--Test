class Task < ApplicationRecord
  # Validations ----
  validates :title, :original_url, :created_by_user_id, :created_by_user_email, presence: true

  # Enums ----------
  enum status: { pending: 0, processing: 1, done: 2, failed: 3 }
end
