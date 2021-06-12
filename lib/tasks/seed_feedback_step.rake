# frozen_string_literal: true

namespace :feedback_step do
  task seed: :environment do
    User.update_all(feedback_plan_step: 5)
  end
end
