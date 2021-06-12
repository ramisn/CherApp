# frozen_string_literal: true

require 'test_helper'

class ActivityMailerTest < ActionMailer::TestCase
  test 'it success sending a share post email' do
    user = User.new(email: 'miguel@cher.app', role: :co_borrower, first_name: 'Miguel', last_name: 'Urbina')
    mail = ActivityMailer.share_post({ link: 'https://cher.app/activities/1',
                                       body: 'Take a look at this post',
                                       recipient: 'miguel@example.com',
                                       user_name: user.full_name },
                                     user)

    assert_equal ['cher@cher.app'], mail.from
    assert_equal "Your friend #{user.full_name} is very active at Cher and wants you to check it out", mail.subject
    assert_equal ['miguel@example.com'], mail.to
    assert_match "Your friend, #{user.full_name}, has shared a post on Cher.", mail.body.encoded
  end

  test 'it does not send email if user does not accept post notification' do
    user = User.new(email: 'miguel@cher.app', role: :co_borrower, first_name: 'Miguel', last_name: 'Urbina')
    co_borrower = users(:co_borrower_user)
    co_borrower.notification_settings.update!(preferences: { post_share_email: 0 })

    ActivityMailer.share_post({ link: 'https://cher.app/activities/1',
                                body: 'Take a look at this post',
                                recipient: co_borrower.email },
                              user).deliver_now
    assert_emails 0
  end

  test 'it success sending a property share email' do
    user = users(:co_borrower_user)

    mail = ActivityMailer.share_property({ link: 'https://cher.app/properties/123ABC',
                                           body: 'Take a look at this house',
                                           recipient: 'miguel@example.com',
                                           user_name: user.full_name },
                                         user)

    assert_equal ['cher@cher.app'], mail.from
    assert_equal "Your friend #{user.full_name} finds you a perfect house at Cher.", mail.subject
    assert_equal ['miguel@example.com'], mail.to
    assert_match "#{user.full_name} wants to share a home with you on Cher", mail.body.encoded
  end

  test 'it does not send email if user does not accept property share notifications' do
    user = users(:co_borrower_user)
    co_borrower = users(:co_borrower_user_2)
    co_borrower.notification_settings.update!(preferences: { home_share_email: 0 })

    ActivityMailer.share_property({ link: 'https://cher.app/properties/123ABC',
                                    body: 'Take a look at this house',
                                    recipient: co_borrower.email },
                                  user).deliver_now

    assert_emails 0
  end

  test 'it success sending a review share email' do
    user = users(:co_borrower_user)

    mail = ActivityMailer.share_review({ body: 'Would you mind?', recipient: 'miguel@example.com' }, user)

    assert_equal ['cher@cher.app'], mail.from
    assert_equal "Create your free account to leave #{user.full_name} a review", mail.subject
    assert_equal ['miguel@example.com'], mail.to
    assert_match 'Would you mind taking 30 seconds', mail.body.encoded
  end

  test 'it does not send email if user does not accept review notifications' do
    user = users(:co_borrower_user)
    co_borrower = users(:co_borrower_user_2)
    co_borrower.notification_settings.update!(preferences: { review_share_email: 0 })

    ActivityMailer.share_review({ body: 'Would you mind?',
                                  recipient: co_borrower.email },
                                user)
                  .deliver_now

    assert_emails 0
  end

  test 'it success sending a video share email' do
    user = users(:co_borrower_user)
    mail = ActivityMailer.share_video({ body: 'I just watched this video',
                                        video_url: 'https://youtube.com',
                                        recipient: 'miguel@example.com',
                                        user_name: user.full_name }, user)

    assert_equal ['cher@cher.app'], mail.from
    assert_equal "#{user.full_name} wants to share you a video from Cher", mail.subject
    assert_equal ['miguel@example.com'], mail.to
    assert_match "#{user.full_name} has shared Cher", mail.body.encoded
  end

  test 'it does not send email if user does not accept video notifications' do
    co_borrower = users(:co_borrower_user_2)
    co_borrower.notification_settings.update!(preferences: { video_share_email: 0 })
    ActivityMailer.share_video({ body: 'I just watched this video',
                                 video_url: 'https://youtube.com',
                                 recipient: co_borrower.email }, co_borrower).deliver_now

    assert_emails 0
  end

  test 'it success sending newsletter subscribe email' do
    mail = ActivityMailer.newsletter_subscribe('miguel@cher.app')

    assert_equal ['miguel@cher.app'], mail.to
    assert_equal ['cher@cher.app'], mail.from
    assert_equal 'Thanks for subscribing Cher!', mail.subject
    assert_match 'Thanks for joining Cher', mail.body.encoded
  end

  test 'it does not send email if user does not accept subscription notificatios' do
    co_borrower = users(:co_borrower_user_2)
    co_borrower.notification_settings.update!(preferences: { subscription_email: 0 })

    ActivityMailer.newsletter_subscribe(co_borrower.email).deliver_now

    assert_emails 0
  end

  test 'it success sending weekly email' do
    WebStub.stub_properties_request
    user = users(:co_borrower_user_2)
    properties = TopPropertiesService.new(user).execute
    mail = ActivityMailer.weekly_properties_drip(properties, user)

    assert_equal [user.email], mail.to
    assert_equal ['cher@cher.marketing'], mail.from
    assert_equal 'Cher found these homes that you might like', mail.subject
    assert_match 'We found these homes that you might like', mail.body.encoded
  end

  test 'it success sending weekly leads email' do
    WebStub.stub_properties_request
    user = users(:clique_agent)
    drip_data = FetchWeeklyLeadsDataService.new(user).execute
    mail = ActivityMailer.weekly_leads_drip(drip_data, user)

    assert_equal [user.email], mail.to
    assert_equal ['cher@cher.marketing'], mail.from
    assert_match '1 buyers are looking for homes in Santa Monica', mail.subject
    assert_match '1 buyers are looking for homes in Santa Monica', mail.body.encoded
  end

  test 'it success sending a new chat message' do
    user = users(:co_borrower_user)
    mail = ActivityMailer.share_new_chat_message({ recipient_name: 'Gerald Amezcua',
                                                   recipient: 'miguel@cher.app',
                                                   link: 'https://cher.app/conversation/123',
                                                   user_name: 'Miguel Aguilar' }, user)

    assert_equal ['cher@cher.app'], mail.from
    assert_equal 'New chat message on Cher', mail.subject
    assert_equal ['miguel@cher.app'], mail.to
    assert_match 'You have received a new chat message', mail.body.encoded
  end

  test 'it success sending lead credit email' do
    co_borrower = users(:co_borrower_user)
    agent = users(:agent_user)
    mail = ActivityMailer.new_agent_lead_credit(agent_email: agent.email, user_email: co_borrower.email, date: DateTime.current)

    assert_equal 'A lead used a credit!', mail.subject
    assert_match 'A real estate agent has paid for lead credits on our platform.', mail.body.encoded
    assert_equal [ENV['CONCIERGE_CHAT_EMAIL']], mail.to
  end

  test 'it succeeds sending user contacted email' do
    co_borrower = users(:co_borrower_user)
    mail = ActivityMailer.notify_contacted_lead(co_borrower.email)

    assert_equal 'Knock, Knock!🏡✨', mail.subject
    assert_match 'An agent in your area has sent you a message!', mail.body.encoded
    assert_equal [co_borrower.email], mail.to
  end
end
