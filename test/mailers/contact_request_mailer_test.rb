# frozen_string_literal: true

require 'test_helper'

class ContactRequestMailerTest < ActionMailer::TestCase
  test 'it success sending a new inquiry email' do
    mail = ContactRequestMailer.notify_property_without_professional(user: co_borrower, property: { 'area' => 'Ventura' })

    assert_equal 'No Realtor in the area', mail.subject
    assert_match 'for a property in Ventura', mail.body.encoded
    assert_equal [ENV['ERIC_EMAIL'], ENV['PAUL_EMAIL']], mail.to
  end

  private

  def co_borrower
    User.new(email: 'miguel@cher.app', password: 'Password1', role: :co_borrower, first_name: 'Miguel')
  end
end
