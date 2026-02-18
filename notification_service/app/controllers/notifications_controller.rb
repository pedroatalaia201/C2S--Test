class NotificationsController < ApplicationController
  before_action :set_notif, only: %i[show destoy]

  def index
    render json: Notification.where(user_id: params[:user_id]), status: :ok
  end

  def show
    render json: @notif, status: :ok
  end

  def create
    notif = Notification.new(**notif_params)

    if notif.save
      render json: notif, status: :created
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
    params.permit(:task_id, :event_type, :user_id, :user_email, :collected_data)
  end
end
