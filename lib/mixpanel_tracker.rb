# frozen_string_literal: true

require 'mixpanel-ruby'

class MixpanelTracker
  MIXPANEL_TOKEN = ENV['MIXPANEL_TOKEN']

  # rubocop:disable Metrics/AbcSize
  def self.setup_user(user, mixpanel_data)
    return unless !mixpanel_data.blank? && (Rails.env.production? || Rails.env.staging?)

    tracker.people.set(mixpanel_data['distinct_id'],
                       '$email': user.email,
                       'user_id': user.id,
                       'provider': user.provider_name,
                       'role': user.general_role_name,
                       **utm_data(mixpanel_data))
    tracker.alias(user.email, mixpanel_data['distinct_id'])
  end
  # rubocop:enable Metrics/AbcSize

  def self.update_user(user, user_data, ip = nil)
    return unless Rails.env.production? || Rails.env.staging?

    tracker.people.set(user.email, user_data, ip)
  end

  def self.track_sign_up(user, mixpanel_data)
    return unless !mixpanel_data.blank? && (Rails.env.production? || Rails.env.staging?)

    track_params = { 'provider': user.provider_name,
                     'user type': user.general_role_name,
                     'registration date': user.created_at,
                     'user email': user.email,
                     **utm_data(mixpanel_data) }
    track_event(mixpanel_data['distinct_id'], 'Sign Up', track_params)
  end

  def self.track_log_in(user, ip)
    return unless Rails.env.production? || Rails.env.staging?

    update_user(user, { '$ip': ip }, ip)
  end

  def self.track_event(user_email, event_name, params = {})
    return unless Rails.env.production? || Rails.env.staging?

    tracker.track(user_email, event_name, params)
  end

  def self.tracker
    @tracker ||= Mixpanel::Tracker.new(MIXPANEL_TOKEN)
  end

  def self.utm_data(mixpanel_data)
    source = mixpanel_data['utm_source'] || ''
    campaign = mixpanel_data['utm_campaign'] || ''
    ip = mixpanel_data['$ip'] || ''

    { 'source': source, 'campaign': campaign, '$ip': ip }
  end
end
