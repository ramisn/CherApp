# frozen_string_literal: true

require 'MailchimpMarketing'

$mailchimp = MailchimpMarketing::Client.new
$mailchimp.set_config(
  api_key: ENV['MAILCHIMP_API_KEY'],
  server: ENV['MAILCHIMP_SERVER']
)
