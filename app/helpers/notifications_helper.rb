# frozen_string_literal: true

module NotificationsHelper
  def account_confirmation_message(_notification)
    content_tag :span, class: 'is-block in-app-notification-description' do
      concat(content_tag(:span, t('generic.cher'), class: 'is-bold'))
      concat(tag.br)
      concat(content_tag(:span, t('notifications.confirm_account'), class: 'notification-message is-block'))
    end
  end

  def complete_profile_message(_notification)
    content_tag :span, class: 'is-block in-app-notification-description' do
      concat(content_tag(:span, t('generic.cher'), class: 'is-bold'))
      concat(tag.br)
      concat(content_tag(:span, t('notifications.complete_profile'), class: 'notification-message is-block'))
    end
  end

  def conversation_request_message(notification)
    content_tag :span, class: 'is-block in-app-notification-description' do
      concat(content_tag(:span, owner_identifier(notification), class: 'is-bold'))
      concat(tag.br)
      concat(content_tag(:span, t('notifications.conversation_request'), class: 'notification-message is-block'))
    end
  end

  def flagged_property_message(notification)
    content_tag :span, class: 'is-block in-app-notification-description' do
      concat(content_tag(:span, owner_identifier(notification), class: 'is-bold'))
      concat(tag.br)
      concat(content_tag(:span, t('notifications.flagged_property', city: notification.params['city']), class: 'notification-message is-block'))
    end
  end

  def friend_request_message(notification)
    content_tag :span, class: 'is-block in-app-notification-description' do
      concat(content_tag(:span, owner_identifier(notification), class: 'is-bold'))
      concat(tag.br)
      concat(content_tag(:span, t('notifications.friend_request_received'), class: 'notification-message is-block'))
    end
  end

  def message_sent_message(notification)
    content_tag :span, class: 'is-block in-app-notification-description' do
      concat(content_tag(:span, owner_identifier(notification), class: 'is-bold'))
      concat(tag.br)
      concat(content_tag(:span, t('notifications.message_received'), class: 'notification-message is-block'))
    end
  end

  def review_request_message(notification)
    content_tag :span, class: 'is-block in-app-notification-description' do
      concat(content_tag(:span, owner_identifier(notification), class: 'is-bold'))
      concat(tag.br)
      concat(content_tag(:span, t('notifications.review_requested'), class: 'notification-message is-block'))
    end
  end

  def share_property_message(notification)
    content_tag :span, class: 'is-block in-app-notification-description' do
      concat(content_tag(:span, owner_identifier(notification), class: 'is-bold'))
      concat(tag.br)
      concat(content_tag(:span, t('notifications.share_property'), class: 'notification-message is-block'))
    end
  end

  def contact_realtor_message(notification)
    content_tag :span, class: 'is-block in-app-notification-description' do
      concat(content_tag(:span, owner_identifier(notification), class: 'is-bold'))
      concat(tag.br)
      concat(content_tag(:span, t('notifications.contact_realtor'), class: 'notification-message is-block'))
    end
  end

  def notification_check_box_input(attribute)
    check_box('notification_settings',
              "preferences[#{attribute}]",
              checked: user_accept_notification_type?(attribute),
              class: 'is-checkradio is-small',
              id: "notification_settings_#{attribute}")
  end

  def notification_message(notification)
    send("#{notification.key}_message", notification)
  end

  def redirect_notification_path(notification)
    return '#' if notification.key == 'account_confirmation'
    return edit_profile_path(notification.owner) if notification.key == 'complete_profile'
    return conversation_path(notification.owner) if %w[conversation_request contact_realtor].include?(notification.key)
    return notification.params&.dig('link') if %w[message_sent share_property].include?(notification.key)
    return user_path(notification.owner) if notification.key == 'review_request'

    social_networks_path
  end

  def notification_image(notification)
    if notification.key == 'complete_profile' || notification.key == 'account_confirmation'
      'cherapp-ownership-coborrowing-cher-logo.png'
    else
      notification.owner.profile_image
    end
  end

  def user_accept_notification_type?(attribute)
    preference_value = user_notification_settings.preferences[attribute] if user_notification_settings
    preference_value.nil? || preference_value == '1'
  end

  def user_notification_settings
    @user_notification_settings ||= current_user.notification_settings
  end

  def owner_identifier(notification)
    notification.owner.full_name.blank? ? notification.owner.email : notification.owner.full_name
  end
end
