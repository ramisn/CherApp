# frozen_string_literal: true

require 'test_helper'

class UnprospectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auth_headers = { 'Authorization' => "Basic #{Base64.encode64("#{ENV['SENDGRID_EVENT_USER']}:#{ENV['SENDGRID_EVENT_PASSWORD']}")}" }
    @miguel_prospect = prospects(:miguel)
    @miguel_contact = Contact.find_or_create_by_prospect(@miguel_prospect)
  end

  test 'it success when trigering a unsubscription' do
    # Useless for now
    skip
    post sendgrid_events_path, params: { _json: [{ email: @miguel_prospect.email, event: 'unsubscribe' }] }, headers: @auth_headers

    assert_response :success
    @miguel_contact.reload
    assert @miguel_contact.unsubscribe?
  end

  test 'it success when trigering a spam report' do
    # Useless for now
    skip
    post sendgrid_events_path, params: { _json: [{ email: @miguel_prospect.email, event: 'spamreport' }] }, headers: @auth_headers

    assert_response :success
    @miguel_contact.reload
    assert @miguel_contact.spamreport?
  end

  test 'it success when unknown event' do
    # Useless for now
    skip
    post sendgrid_events_path, params: { _json: [{ email: @miguel_prospect.email, event: 'exampleaction' }] }, headers: @auth_headers

    assert_response :success
  end

  test 'it success when triggering bounce' do
    # Useless for now
    skip
    post sendgrid_events_path, params: { _json: [{ email: @miguel_prospect.email, event: 'bounce' }] }, headers: @auth_headers

    assert_response :success
    @miguel_contact.reload
    assert @miguel_contact.bounce?
  end

  test 'it success when trigering unsubscribe from specific group' do
    # Useless for now
    skip
    post sendgrid_events_path, params: { _json: [{ email: @miguel_prospect.email, event: 'group_unsubscribe' }] }, headers: @auth_headers

    assert_response :success
    @miguel_contact.reload
    refute @miguel_contact.groupunsubscribe?
  end
end
