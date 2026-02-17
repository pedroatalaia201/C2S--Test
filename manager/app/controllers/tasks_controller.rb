class TasksController < ApplicationController
  def create
    task = Task.new(
      **task_params.merge(
        created_by_user_id: @current_user['id'], created_by_user_email: @current_user['email']
      )
    )

    if task.save
      # Sent even for notification
      # Start the Worker here.
      render json: { message: 'processing' }, status: :ok
    else
      render json: { error: task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def task_params
    params.permit(:title, :original_url)
  end
end
