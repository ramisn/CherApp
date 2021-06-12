# frozen_string_literal: true

class GoogleAnalytics
  GOOGLE_ANALYTICS_TRACKING_CODE = ENV['GOOGLE_ANALYTICS_TRACKING_CODE']

  def self.track_new_user(user, campaign_data = {})
    source = campaign_data['utm_source']
    campaign = campaign_data['utm_campaign']
    event_data = { category: 'User registration',
                   action: 'A new user has registered',
                   value: user.id,
                   campaign_source: source,
                   campaign_name: campaign }.reject { |_k, v| v.blank? } # cn, cs are special attribute son GA
    tracker.event(event_data)
  end

  def self.track_completed_profile(user)
    user_role = if user.co_borrower?
                  'Co-Owner'
                else
                  I18n.t("professional_roles.#{user.professional_role}")
                end
    tracker.event(category: 'Complete Profile', action: "#{user_role} completed profile", value: user.id)
  end

  def self.tracker
    @tracker ||= Staccato.tracker(GOOGLE_ANALYTICS_TRACKING_CODE, nil, ssl: true)
  end
end
