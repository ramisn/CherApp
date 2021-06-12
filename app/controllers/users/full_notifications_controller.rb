# frozen_string_literal: true

module Users
  class FullNotificationsController < AuthenticationsController
    before_action :set_recipient, only: %i[create]

    def create
      respond_to do |format|
        format.json do
          ActivityMailer.send("share_#{full_notification_params[:type]}", email_params, current_user).deliver_later
          Notification.send("registry_#{full_notification_params[:type]}", notification_params)
          SendShareableTextMessageJob.perform_later(message_params) if @recipient.phone_number

          render json: { message: t('flashes.emails.create.success') }, status: 200
        end
      end
    end

    private

    def full_notification_params
      params.require(:full_notification).permit(:link, :recipient, :type, :property_id)
    end

    def email_params
      { recipient_name: full_notification_params[:recipient],
        link: full_notification_params[:link],
        recipient: @recipient.email,
        property_id: full_notification_params[:property_id] }
    end

    def message_params
      { link: full_notification_params[:link],
        recipient: @recipient.phone_number,
        type: full_notification_params[:type],
        user_name: current_user.full_name,
        recipient_name: @recipient.full_name,
        ending: false }
    end

    def notification_params
      { owner: current_user, recipient: @recipient, link: full_notification_params[:link] }
    end

    def set_recipient
      @recipient = User.find_by(email: full_notification_params[:recipient])
    end
  end
end
