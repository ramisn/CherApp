# frozen_string_literal: true

namespace :db do
  desc 'This task include new models on multisearch'
  task :add_multisearch, [:model_name] => :environment do |_task, args|
    model_multisearch = args.model_name.capitalize
    begin
      model_multisearch.constantize.find_each(&:save!)
    rescue StandardError => e
      Rails.logger.error("error: #{e.message}")
    end
  end

  desc 'Update default notifications settings'
  task set_default_user_notifications: :environment do
    User.all.each do |user|
      current_preferences = user.notification_settings.preferences
      current_preferences.merge!(flagged_home_email: 0, flagged_home_sms: 0)
      user.notification_settings.update!(preferences: current_preferences)
    end
  end
end
