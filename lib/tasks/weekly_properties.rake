# frozen_string_literal: true

namespace :weekly_properties do
  task send_emails: :environment do
    SendWeeklyPropertiesService.new.execute
  end
end
