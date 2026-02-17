class CreateTask < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string  :title
      t.integer :status, default: 0
      t.string  :original_url, null: false
      t.integer :created_by_user_id, null: false
      t.string  :created_by_user_email, null: false
      t.jsonb   :collected_data, null: false, default: {}
      t.timestamps
    end
  end
end
