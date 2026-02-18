class CreateNotification < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :event_type, default: 0
      t.integer :task_id, null: false
      t.integer :user_id, null: false
      t.string  :user_email, null: false
      t.jsonb   :collected_data
    end
  end
end
