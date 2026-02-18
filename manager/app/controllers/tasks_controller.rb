class TasksController < ApplicationController
  before_action :set_task, only: %i[show]

  def index
    render json: Task.where(created_by_user_id: @current_user['id']), status: :ok
  end

  def show
    if @task.created_by_user_id.to_i == @current_user['id'].to_i
      render json: @task, status: :ok
    else
      render json: { error: 'User not authorized' }, status: :unauthorized
    end
  end

  def create
    task = Task.new(
      **task_params.merge(
        created_by_user_id: @current_user['id'], created_by_user_email: @current_user['email']
      )
    )

    if task.save
      NotificationServiceClient.new.create(
        task_id: task.id, event_type: 'task_created', collected_data: nil,
        user_id: @current_user['id'], user_email: @current_user['email']
      )
      WebScrapingJob.perform_async(task.id)

      render json: { message: 'processing' }, status: :ok
    else
      render json: { error: task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if task.created_by_user_id.to_i == @current_user['id'].to_i
      @task.destroy
    else
      render json: { error: 'User not authorized' }, status: :unauthorized
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.permit(:title, :original_url)
  end
end
