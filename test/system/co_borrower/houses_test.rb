# frozen_string_literal: true

require 'application_system_test_case'

class HouseTest < ApplicationSystemTestCase
  def setup
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    WebStub.stup_ghost_blog_post
    WebStub.stub_redis_properties
    login_as users(:co_borrower_user)
  end

  test 'user can access to house sell' do
    visit root_path
    page.execute_script 'window.scrollBy(0,10000)'
    find('.go-profile').hover
    rental_window = window_opened_by { click_link 'Sell Home' }

    within_window rental_window do
      assert_content 'For sale'
    end
  end

  test 'user can post a house for sale' do
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    WebStub.stub_properties_request
    image = fixture_file_upload('files/person.jpg', 'image/jpg')
    visit new_co_borrower_house_path

    select 'Condo', from: 'Home type'
    fill_in 'Address', with: '123 Main Street'
    select 'CA', from: 'State'
    fill_in 'Set your price', with: 2_000_000
    attach_file('Picture', image.path, visible: false)
    fill_in 'What % of this home are you selling?', with: 100
    fill_in 'What is the expected down payment?', with: 100
    fill_in 'What are the monthly mortgage payments?', with: 100
    fill_in 'Interior sq. ft.', with: 100
    fill_in 'Beds', with: 2
    fill_in 'Full baths', with: 2
    fill_in '1/2 baths', with: 1
    fill_in 'Basement sq. ft.', with: 100
    fill_in 'Lot size', with: 150
    fill_in 'County', with: 'Alameda'
    fill_in 'What % of this home do you own?', with: 100
    fill_in 'Phone number', with: '1332764492'
    fill_in 'Email', with: 'user@email.com'
    find('label[for="house_accept_terms"]').click
    click_button 'Post for sale by owner'

    assert_content 'House successfully registered'
  end

  test 'user can save draft' do
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    WebStub.stub_properties_request
    image = fixture_file_upload('files/person.jpg', 'image/jpg')
    visit new_co_borrower_house_path

    fill_in 'County', with: 'Alameda'
    select 'Condo', from: 'Home type'
    fill_in 'Address', with: '123 Main Street'
    select 'CA', from: 'State'
    fill_in 'Set your price', with: 2_000_000
    attach_file('Picture', image.path, visible: false)
    click_button 'Save Draft'

    assert_content 'Draft saved correctly'
  end

  test 'user can continue saving house after saving as draft' do
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    WebStub.stub_properties_request
    visit new_co_borrower_house_path

    fill_in 'County', with: 'Alameda'
    select 'Condo', from: 'Home type'
    fill_in 'Address', with: '123 Main Street'
    select 'CA', from: 'State'
    fill_in 'Set your price', with: 2_000_000
    page.execute_script 'window.scrollBy(0,10000)'
    click_button 'Save Draft'

    visit new_co_borrower_house_path
    assert_content 'Draft opened correctly'
  end

  test 'user cannot post house if not all inputs are set' do
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    WebStub.stub_properties_request
    image = fixture_file_upload('files/person.jpg', 'image/jpg')
    visit new_co_borrower_house_path

    fill_in 'County', with: 'Alameda'
    select 'Condo', from: 'Home type'
    fill_in 'Address', with: '123 Main Street'
    select 'CA', from: 'State'
    fill_in 'Set your price', with: 2_000_000
    attach_file('Picture', image.path, visible: false)
    click_button 'Post for sale by owner'

    assert_content 'Error registering house'
  end
end
