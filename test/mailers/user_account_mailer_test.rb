# frozen_string_literal: true

require 'test_helper'

class UserAccountMailerTest < ActionMailer::TestCase
  test 'it send email with user default notification settings' do
    user = users(:co_borrower_user)

    UserAccountMailer.with(user: user).background_check_approved.deliver_now

    assert_emails 1
  end

  test 'it success sending a background check approved email' do
    user = users(:co_borrower_user)

    mail = UserAccountMailer.with(user: user).background_check_approved

    assert_equal ['cher@cher.app'], mail.from
    assert_equal 'Cher - Background Check Approved', mail.subject
    assert_equal [user.email], mail.to
    assert_match 'Your background check has been approved', mail.body.encoded
  end

  test 'it does not send email if user does not accept background check notifications' do
    user = users(:co_borrower_user)
    user.notification_settings.update!(preferences: { background_check_email: 0 })

    UserAccountMailer.with(user: user).background_check_approved.deliver_now

    assert_emails 0
  end

  test 'it success sending a background check rejected email' do
    user = users(:co_borrower_user)

    mail = UserAccountMailer.with(user: user).background_check_denied

    assert_equal ['cher@cher.app'], mail.from
    assert_equal 'Cher - Background Check Denied', mail.subject
    assert_equal [user.email], mail.to
    assert_match 'Your background check was denied.', mail.body.encoded
  end

  test 'it success sending a rent listed' do
    user = users(:co_borrower_user)

    mail = UserAccountMailer.with(user: user).listing_rental

    assert_equal 'Listing Confirmation', mail.subject
    assert_equal ['cher@cher.app'], mail.from
    assert_equal [user.email], mail.to
    assert_match 'You have successfully listed a property on Cher!', mail.body.encoded
  end

  test 'it does not send email if user does not accept listing notifications' do
    user = users(:co_borrower_user)
    user.notification_settings.update!(preferences: { listing_email: 1 })

    UserAccountMailer.with(user: user).listing_rental.deliver_now

    assert_emails 0
  end

  test 'it success sending a clique premium confirmation' do
    professional = users(:agent_user)
    professional.update!(plan_type: 'premium')
    mail = UserAccountMailer.with(user: professional).clique_payment_success

    assert_equal ['cher@cher.app'], mail.from
    assert_equal "Cher's Clique Monthly Subscription Confirmation", mail.subject
    assert_equal [professional.email], mail.to
    assert_match 'we are thrilled to have you as a member of Cher Premium Agent!', mail.body.encoded
    assert_match "Hi #{professional.first_name}, your payment for a monthly subscription has been confirmed", mail.body.encoded
  end

  test 'it does not send email if user does not accept clique notifications' do
    professional = users(:agent_user)
    professional.update!(plan_type: 'premium')
    professional.notification_settings.update!(preferences: { chers_clique_email: 0 })

    UserAccountMailer.with(user: professional).clique_payment_success.deliver_now

    assert_emails 0
  end

  test 'it success sending deleted account email' do
    user = users(:agent_user)

    mail = UserAccountMailer.with(user: user).delete_account

    assert_equal "Cher - We're Sad To See You Go", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['cher@cher.app'], mail.from
    assert_match "I'm sorry to see you go.", mail.body.encoded
  end

  test 'it does not send email if user does no accept delete account notifications' do
    user = users(:agent_user)
    user.notification_settings.update!(preferences: { delete_account_email: 0 })

    UserAccountMailer.with(user: user).delete_account.deliver_now

    assert_emails 0
  end

  test 'it success sending cher clique about to end email' do
    professional = users(:agent_user)

    mail = UserAccountMailer.with(user: professional, last4: '1234').clique_about_to_end

    assert_equal 'Your subscription will renew soon', mail.subject
    assert_equal [professional.email], mail.to
    assert_equal ['cher@cher.app'], mail.from
    assert_match "#{professional.first_name}, this is a friendly reminder that your Cher Clique Agent", mail.body.encoded
    assert_match 'will automatically renew on', mail.body.encoded
  end

  test 'it does not send email if last4 does not exist' do
    professional = users(:agent_user)

    UserAccountMailer.with(user: professional).clique_about_to_end.deliver_now

    assert_emails 0
  end

  test 'clique about to end without name user proffesional email' do
    professional = users(:agent_user)
    professional.update(first_name: nil, last_name: nil)

    mail = UserAccountMailer.with(user: professional, last4: '1234').clique_about_to_end

    assert_equal 'Your subscription will renew soon', mail.subject
    assert_equal [professional.email], mail.to
    assert_equal ['cher@cher.app'], mail.from
    assert_match "#{professional.email}, this is a friendly reminder", mail.body.encoded
    assert_match 'will automatically renew on', mail.body.encoded
  end

  test 'it does not send email if user does not receive clique expiration notifications' do
    professional = users(:agent_user)
    professional.notification_settings.update!(preferences: { clique_expiration_email: 0 })

    UserAccountMailer.with(user: professional).clique_about_to_end.deliver_now

    assert_emails 0
  end

  test 'it success sending a flagged home email' do
    user = users(:co_borrower_user)
    friend = users(:co_borrower_user_2)
    mail = UserAccountMailer.with(user: user, recipient: friend, address: 'Santa Monica').flagged_home_by_friend

    assert_equal [friend.email], mail.to
    assert_equal ['cher@cher.app'], mail.from
    assert_equal 'A friend on Cher has flagged a home!', mail.subject
    assert_match "Your friend, #{friend.first_name}", mail.body.encoded
    assert_match ' have recently flagged a home in Santa Monica!', mail.body.encoded
  end

  test 'it does not send email if user does not accept flagged home notifications' do
    user = users(:co_borrower_user)
    friend = users(:co_borrower_user_2)
    friend.notification_settings.update!(preferences: { flagged_home_email: 0 })

    UserAccountMailer.with(user: user, recipient: friend, city: 'Santa Monica').flagged_home_by_friend.deliver_now

    assert_emails 0
  end

  test 'it success sending a friend request mail' do
    friend_request = friend_requests(:co_borrower_user_2_request)

    mail = UserAccountMailer.with(user: friend_request.requester, requestee: friend_request.requestee).friend_request

    assert_equal [friend_request.requestee.email], mail.to
    assert_equal ['cher@cher.app'], mail.from
    assert_equal 'Request to connect from user', mail.subject
    assert_match "Hello #{friend_request.requestee.first_name}", mail.body.encoded
    assert_match "#{friend_request.requester.first_name} has requested to connect with you on Cher.", mail.body.encoded
  end

  test 'it does not send email if user does not accept friend request notifications' do
    friend_request = friend_requests(:co_borrower_user_2_request)
    friend_request.requestee.notification_settings.update!(preferences: { friend_request_email: 0 })

    UserAccountMailer.with(user: friend_request.requester, requestee: friend_request.requestee).friend_request.deliver_now

    assert_emails 0
  end

  test 'it send email with default email config' do
    user = users(:co_borrower_user)
    friend = users(:co_borrower_user_2)
    UserAccountMailer.with(user: user, recipient: friend, city: 'Santa Monica').flagged_home_by_friend.deliver_now

    assert_emails 1
  end

  test 'it does not send email if contact status is bounced' do
    contact_user = contacts(:co_borrower_contact)
    contact_user.update!(status: :bounce)
    user = users(:co_borrower_user)
    friend = users(:co_borrower_user_2)
    UserAccountMailer.with(user: user, recipient: friend, city: 'Santa Monica').flagged_home_by_friend.deliver_now

    assert_emails 0
  end
end
