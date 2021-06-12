# frozen_string_literal: true

require 'csv'

namespace :topics do
  task :populate_through_csv, [:filename] => :environment do |_task, args|
    filename = Rails.root.join(args[:filename])
    CSV.foreach(filename) do |row|
      Topic.create!(name: row[0], rich_body: row[1])
    end
  end
end
