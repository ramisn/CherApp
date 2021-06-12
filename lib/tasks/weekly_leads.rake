# frozen_string_literal: true

namespace :weekly_leads do
  task send_emails: :environment do
    SendWeeklyCustomerLeadsService.new.execute
  end
end
