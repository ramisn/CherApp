# frozen_string_literal: true

class NotificationSettingsController < AuthenticationsController
  before_action :find_settings

  def edit; end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def update
    respond_to do |format|
      format.html do
        # TODO(KARLA): REFACTOR THIS CODE
        if @notification_settings.update(notifications_settings_params)
          flash[:notice] = t('flashes.notification_settings.update.notice')
          if current_user.agent?
            redirect_to customer_dashboard_path
          else
            redirect_to co_borrower_dashboard_path
          end
        else
          flash[:alert] = t('flashes.notification_settings.update.alert')
          render 'edit'
        end
      end

      format.json do
        @notification_settings.update(notifications_settings_params)
        render json: {}, status: 200
      end
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength Metrics/AbcSize

  private

  def find_settings
    @notification_settings = current_user.notification_settings
  end

  def notifications_settings_params
    params.require(:notification_settings)
          .permit(preferences: {})
  end
end
