# frozen_string_literal: true

namespace :property_prices do
  task set: :environment do
    SetPropertyPricesService.new.execute
  end
end
