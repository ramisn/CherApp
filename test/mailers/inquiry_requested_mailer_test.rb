# frozen_string_literal: true

require 'test_helper'

class InquiryRequestedMailerTest < ActionMailer::TestCase
  test 'it success sending a new inquiry email' do
    mail = InquiryRequestedMailer.notify_admin(first_name: 'Miguel', middle_name: 'Angel', last_name: 'Urbina', date_of_birth: '01/13/1997')

    assert_equal 'New inquiry requested', mail.subject
    assert_match 'Miguel has requested an inquiry.', mail.body.encoded
  end

  test 'it success sending a background check report' do
    users_who_requested = User.where(role: :co_borrower)
    mail = InquiryRequestedMailer.send_pending_requests_csv(users_who_requested)

    assert_equal 'Pending backgorund check report', mail.subject
    assert_match 'There are some background check requests pending', mail.body.encoded
  end
end
