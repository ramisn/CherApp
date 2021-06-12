# frozen_string_literal: true

require 'application_system_test_case'

class PropertiesTest < ApplicationSystemTestCase
  def setup
    WebStub.stub_properties_request
    WebStub.stub_property_places
    WebStub.stub_walkscore
    WebStub.stub_attom
    WebStub.stub_frankenstein
    WebStub.stub_twilio_sms
    WebStub.stub_bitly
  end

  test 'user can see a property' do
    visit property_path('13322')

    assert page.has_content?('Overview')
  end

  test 'user see not found view when property is not available' do
    WebStub.stub_empty_properties_response
    WebStub.stub_redis_null
    visit property_path('13322')

    assert page.has_content?('Seems like this home is not available anymore')
  end

  test 'user can share a property through email' do
    visit property_path('13322')

    click_button 'Share'
    fill_in 'email[user_contact]', with: 'miguel@cher.app'
    fill_in 'email[user_first_name]', with: 'Miguel'
    fill_in 'email[user_last_name]', with: 'Urbina'
    fill_in 'email[recipient_contact]', with: 'harold@cher.app'
    fill_in 'email[recipient_first_name]', with: 'Alfred'
    fill_in 'email[recipient_last_name]', with: 'Donald'
    fill_in 'email[body]', with: 'Take a look at this home'
    find('input.button.is-primary').click

    within('form[data-action="submit->share-item#handleSubmitFull"]') do
      assert_content 'Email sent'
    end
  end

  test 'user can share a property through SMS' do
    visit property_path('13322')
    click_button 'Share'
    fill_in 'email[user_contact]', with: 'miguel@cher.app'
    fill_in 'email[user_first_name]', with: 'Miguel'
    fill_in 'email[user_last_name]', with: 'Urbina'
    fill_in 'email[recipient_contact]', with: '1332186715'
    fill_in 'email[recipient_first_name]', with: 'Alfred'
    fill_in 'email[recipient_last_name]', with: 'Donald'
    fill_in 'email[body]', with: 'Take a look at this home'
    find('input.button.is-primary').click

    within('form[data-action="submit->share-item#handleSubmitFull"]') do
      assert_content 'SMS sent'
    end
  end

  test 'user can copy home link when sharing' do
    visit property_path('13322')
    click_button 'Share'
    find('img[alt="Copy link"]').click

    assert_content 'Link copied'
  end

  test 'user can share home in facebook' do
    visit property_path('13322')
    click_button 'Share'
    within('.share-links') do
      find('img[alt="Facebook account"]').click
    end

    assert 2, page.driver.browser.window_handles.length
  end

  test 'user can share home in LinkedIn' do
    visit property_path('13322')
    click_button 'Share'
    within('.share-links') do
      find('img[alt="LinkedIn account"]').click
    end

    assert 2, page.driver.browser.window_handles.length
  end

  test 'user can share home in twitter' do
    visit property_path('13322')
    click_button 'Share'
    within('.share-links') do
      find('img[alt="Twitter account"]').click
    end

    assert 2, page.driver.browser.window_handles.length
  end

  test 'attom data get more information' do
    visit property_path('13322')
    assert_content 'More details'
    click_button 'More details'
    assert_content "Zoning\nResidential"
    assert_content "Basement size\n715 sqft"
    assert_content "Floors\n2"
    assert_content "Parking size\n100"
  end

  test 'attom data get assessments data' do
    visit property_path('13322')
    click_button 'More details'
    assert_content 'Assessments'
    assert_content '$216,461'
    assert_content '$337,087'
    assert_content '$553,548'
  end

  test 'attom data get tax data' do
    visit property_path('13322')
    click_button 'More details'
    assert_content 'Tax'
    assert_content 'Amount'
    assert_content 'Exemption'
    assert_content 'Additional, Homeowner'
    assert_content 'SHANNON C CISNEROS'
  end

  test 'attom data get mortgage data' do
    visit property_path('13322')
    click_button 'More details'

    assert_content 'Mortgage'
    assert_content 'WELLS FARGO BANK'
    assert_content '$133,107'
  end

  test 'attom data get preforeclosure data' do
    visit property_path('13322')
    click_button 'More details'
    assert_content 'Preforeclosure details'
    assert_content 'MUSTAPHA NJIE'
    assert_content '02 / 21 / 2018'
    assert_content 'Wells Fargo Bank'
    assert_content '3%'
  end

  test "don't print auction data if there no have default data" do
    visit property_path('13322')
    click_button 'More details'
    refute_content 'Marina Pirinola South'
    refute_content '01 / 01 / 1900'
    refute_content '10:30AM'
  end

  test 'attom data get auction data' do
    visit property_path('13322')
    click_button 'More details'
    assert_content 'Saint Maria Mazoru'
    assert_content 'Michitlan'
    assert_content '03 / 03 / 1992'
    assert_content '07:00AM'
  end
end
