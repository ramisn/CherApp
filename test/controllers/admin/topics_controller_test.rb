# frozen_string_literal: true

require 'test_helper'

class Admin::TopicsControllerTest < ActionDispatch::IntegrationTest
  test 'it redirects no admin user to root path when trying to access to topic section' do
    login_as users(:agent_user)

    get admin_topics_path

    assert_redirected_to root_path
  end

  test 'it success whem admin user access to topic section' do
    login_as users(:admin_user)

    get admin_topics_path

    assert_response :success
  end

  test 'it success when admin users access to new topic' do
    login_as users(:admin_user)

    get new_admin_topic_path

    assert_response :success
  end

  test 'it reirect to topics section when admin creates a new topic' do
    login_as users(:admin_user)

    post admin_topics_path, params: { topic: { name: 'What a co-bo is',
                                               rich_body: '<div>A ranodm description</div>' } }

    assert_redirected_to admin_topics_path
  end

  test 'it seccess whena admin access to edit topic section' do
    topic = topics(:co_borrower_topic)
    login_as users(:admin_user)

    get edit_admin_topic_path(topic)

    assert_response :success
  end

  test 'it redirects admin to topics section when updating a topic' do
    topic = topics(:co_borrower_topic)
    login_as users(:admin_user)

    put admin_topic_path(topic), params: { topic: { rich_body: '<div>A ranodm description</div>' } }

    assert_redirected_to admin_topics_path
  end

  test 'it redirects admin to topics section when deleting a topic' do
    topic = topics(:co_borrower_topic)
    login_as users(:admin_user)

    delete admin_topic_path(topic)

    assert_redirected_to admin_topics_path
  end
end
