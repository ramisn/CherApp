# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  ActionController::Base.allow_forgery_protection = true
  include Devise::Test::IntegrationHelpers
  include ActionDispatch::TestProcess

  if ENV['CI']
    Capybara.server = :puma, { Silent: true }
    Capybara.register_driver :ci_headless_chrome do |app|
      options = ::Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless')
      options.add_argument('--no-sandbox')
      options.add_argument('--disable-dev-shm-usage')
      options.add_argument('--disable-gpu')
      options.add_argument('--window-position=1920,0')
      options.add_argument('--window-size=1920,1080')
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.read_timeout = 240
      Capybara::Selenium::Driver.new(app, browser: :chrome, options: options, http_client: client)
    end

    Capybara.javascript_driver = :ci_headless_chrome

    driven_by :ci_headless_chrome
  else
    driven_by :selenium, using: :headless_chrome
  end
end
