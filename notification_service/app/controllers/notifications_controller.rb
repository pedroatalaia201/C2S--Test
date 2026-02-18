class NotificationsController < ApplicationController
  before_action :set_notif, only: %i[show destoy]
  before_action :validate_user, only: %i[show destroy]

  def index
    render json: Notification.where(user_id: @current_user['id']), status: :ok
  end

  def show
    render json: @notif, status: :ok
  end

  def create
    notif = Notification.new(**notif_params)

    if notif.save
      render json: notif, status: :ok
    else
      render json: { error: notif.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @notif.destroy
  end

  private

  def set_notif
    @notif = Notification.find(params[:id])
  end

  def notif_params
    params.permit(:task_id, :user_id, :user_email, :collected_data)
  end

  def validate_user
    if @notif.user_id != @current_user['id']
      render json: { message: 'Is not possible check another users notifications' }, status: :unauthorized
    end
  end
end
