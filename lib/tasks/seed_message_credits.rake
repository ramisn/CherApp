# frozen_string_literal: true

namespace :message_credits do
  task seed: :environment do
    User.agent.where('end_of_clique > ?', Date.today).update_all(message_credits: 5)
  end
end
