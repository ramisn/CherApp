# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative 'support/webmock/web_stub'
require_relative '../config/environment'
require 'rails/test_help'
require 'mocha/minitest'

WebMock.disable_net_connect!(allow_localhost: true,
                             allow: 'chromedriver.storage.googleapis.com')

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end
