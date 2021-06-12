# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'active_model_serializers', '~> 0.10.0'
gem 'active_storage_validations'
gem 'aws-sdk-chime'
gem 'bitly'
gem 'carmen'
gem 'devise'
gem 'devise_invitable', '~> 2.0.0'
gem 'discard', '~> 1.0'
gem 'font_awesome5_rails'
gem 'haml-rails', '~> 2.0'
gem 'jbuilder', '~> 2.7'
gem 'kaminari'
gem 'MailchimpMarketing'
gem 'mixpanel-ruby', '~> 2.2'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-linkedin-oauth2'
gem 'pg', '~> 0.18.4'
gem 'pg_search'
gem 'public_activity'
gem 'puma', '~> 3.11'
gem 'rack-host-redirect'
gem 'rack-proxy', '~> 0.6.4', require: true
gem 'rails', '~> 6.0.0'
gem 'react-rails'
gem 'redis', '~> 4.1', '>= 4.1.3'
gem 'rest-client'
gem 'restforce'
gem 'sass-rails', '~> 5'
gem 'sentry-raven'
gem 'sidekiq'
gem 'skylight'
gem 'staccato'
gem 'stripe-rails'
gem 'turbolinks', '~> 5'
gem 'twilio-ruby', '~> 5.31.1'
gem 'webpacker', '~> 4.0'

# gem 'mimemagic', '~> 0.3.10'

gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  gem 'dotenv-rails'
  gem 'pry', '~> 0.12.2'
  gem 'pry-nav'
  gem 'scss_lint', require: false
end

group :development do
  gem 'annotate'
  gem 'letter_opener'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop', '~> 0.75.0', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'mocha'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'webmock', '~> 3.7', '>= 3.7.6'
end

group :production do
  gem 'aws-sdk-s3'
  gem 'image_processing', '~> 1.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
