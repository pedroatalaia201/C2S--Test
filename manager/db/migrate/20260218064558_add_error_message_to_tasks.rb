class AddErrorMessageToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :error_message, :string
  end
end
