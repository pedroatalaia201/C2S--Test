class Notification < ApplicationRecord
  # Validations ----
  validates :task_id, :user_id, :user_email, presence: true

  # Enums ----------
  enum event_types: { task_created: 0, task_completed: 1, task_failed: 2 }
end
