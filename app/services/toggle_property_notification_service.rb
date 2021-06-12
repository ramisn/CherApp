# frozen_string_literal: true

class TogglePropertyNotificationService
  def initialize(current_user, property_id)
    @current_user = current_user
    @notification_type = "property_#{property_id}"
    @state = current_user.notification_settings.accept_type_notification?(@notification_type)
  end

  def execute
    notification_preference = notification_setting(@state)
    new_preferences = @current_user.notification_settings.preferences.merge(notification_preference)

    result = @current_user.notification_settings.update(preferences: new_preferences)

    response(true, result, I18n.t("notifications.property.#{@state}"))
  end

  private

  def notification_setting(state)
    {
      "#{@notification_type}_email" => state ? '0' : '1',
      "#{@notification_type}_sms" => state ? '0' : '1',
      "#{@notification_type}_in_app" => state ? '0' : '1'
    }
  end

  def response(success, result, message)
    OpenStruct.new(success?: success, message: message, notification_settings: result)
  end
end
