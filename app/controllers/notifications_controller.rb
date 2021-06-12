# frozen_string_literal: true

class NotificationsController < AuthenticationsController
  before_action :set_notification, only: %i[update destroy]

  def index
    page = params[:page].presence || 1
    @received_notifications = current_user.received_notifications
                                          .active
                                          .order(:status, created_at: :desc)
                                          .page(page).per(10)
  end

  def update
    respond_to do |format|
      format.json do
        if @notification.update(notification_params)
          render json: @notification
        else
          render json: @notification, status: 402
        end
      end
    end
  end

  def destroy
    @notification.update(deleted_at: Date.current)

    respond_to do |format|
      format.html do
        redirect_to notifications_path
      end

      format.json do
        render json: @notification
      end
    end
  end

  private

  def set_notification
    @notification = current_user.received_notifications.find(params[:id])
  end

  def notification_params
    params.require(:notification).permit(:status)
  end
end
