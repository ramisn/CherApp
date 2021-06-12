# frozen_string_literal: true

namespace :flagged_properties_changes do
  task send_emails: :environment do
    FlaggedPropertiesChangesService.new.execute
  end
end
