# frozen_string_literal: true

require 'test_helper'

class UsersMailerTest < ActionMailer::TestCase
  test 'it success sending password reset email' do
    user = users(:agent_user)

    mail = UsersMailer.password_reset(user, 'XHCas2Dd2')

    assert_equal 'Cher password reset', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['cher@cher.app'], mail.from
    assert_match 'Click The Button Below To Reset Your Password', mail.body.encoded
  end

  test 'it success sending confirmation email' do
    skip
    user = users(:agent_user)

    mail = UsersMailer.confirmation(user, 'XHCas2Dd2')

    assert_equal "#{user.first_name} Welcome to Cher Clique Agent!", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['cher@cher.app'], mail.from
    assert_match 'welcome to Cher Clique Agent', mail.body.encoded
  end

  test 'it success sending a welcome agent email' do
    professional = users(:agent_user)

    mail = UsersMailer.welcome_agent(professional)

    assert_equal [professional.email], mail.to
    assert_equal ['cher@cher.app'], mail.from
    assert_equal "#{professional.first_name} Welcome to Cher Clique Agent!", mail.subject
    assert_match 'welcome to Cher Clique Agent', mail.body.encoded
  end

  test 'it success sending a welcome co borrower email' do
    user = users(:co_borrower_user)

    mail = UsersMailer.welcome_co_borrower(user)

    assert_equal [user.email], mail.to
    assert_equal ['cher@cher.app'], mail.from
    assert_equal 'Welcome To Cher', mail.subject
    assert_match 'Welcome to Cher®! My name is Russell', mail.body.encoded
  end

  test 'it success sending a loan process invitation' do
    participant = loan_participants(:user_without_role_participant)
    friend = participant.loan.user
    user_identifier = friend.full_name.blank? ? friend.email : friend.full_name

    mail = UsersMailer.notify_loan_invitation(participant)

    assert_equal [participant.email], mail.to
    assert_equal ['cher@cher.app'], mail.from
    assert_equal 'Someone invited you to a loan process', mail.subject
    assert_match "Your friend #{user_identifier} invited you to share the mortgage", mail.body.encoded
  end

  test 'it success sending a loan process completed email' do
    user = users(:co_borrower_user)
    user_identifier = user.full_name.blank? ? user.email : user.full_name

    mail = UsersMailer.notify_loan_completed(user)

    assert_equal [user.email], mail.to
    assert_equal ['cher@cher.app'], mail.from
    assert_equal "#{user_identifier}, you have completed your pre-approval application", mail.subject
    assert_match 'You have completed your pre-approval application', mail.body.encoded
  end

  test 'it success sending a loan pre request email to owner' do
    user = users(:co_borrower_user)
    mail = UsersMailer.notify_loan_owner(user)

    assert_equal [user.email], mail.to
    assert_equal ['cher@cher.app'], mail.from
    assert_equal 'Pre-approval application completed', mail.subject
    assert_match 'You have completed your pre-approval application for a mortgage', mail.body.encoded
  end

  test 'it succcess sending a chat group email' do
    user = users(:co_borrower_user)
    inviter = users(:co_borrower_user_2)
    user_identifier = user.first_name.blank? ? user.email : user.first_name
    inviter_identifier = inviter.first_name.blank? ? inviter.email : inviter.first_name

    mail = UsersMailer.notify_group_chat(user, inviter, '123abc')

    assert_equal [user.email], mail.to
    assert_equal ['cher@cher.app'], mail.from
    assert_equal "#{user_identifier} is inviting you to a group chat", mail.subject
    assert_match "#{user_identifier}, #{inviter_identifier} is inviting you to join the chat.", mail.body.encoded
  end

  test 'it succees sending notify properties changes' do
    user = users(:co_borrower_user)

    mail = UsersMailer.notify_property_changed(user)
    assert_equal [user.email], mail.to
    assert_equal ['cher@cher.app'], mail.from
    assert_equal 'Your DREAM home is calling!', mail.subject
    assert_match 'A home you have recently flagged now has a NEW update! Sign in below to view all changes and updates.', mail.body.encoded
  end
end
