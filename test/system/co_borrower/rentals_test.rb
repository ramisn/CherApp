# frozen_string_literal: true

require 'application_system_test_case'

module Admin
  class RentalsTest < ApplicationSystemTestCase
    setup do
      ChatTokensController.any_instance
                          .stubs(:generate_token)
                          .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
      WebStub.stup_ghost_blog_post
      login_as users(:co_borrower_user)
      visit root_path
      page.execute_script 'window.scrollBy(0,10000)'
      find('.go-profile').hover
    end

    test 'co-borrower can access to rentals index' do
      rental_window = window_opened_by { click_link 'Sell Home' }
      within_window rental_window do
        assert_content 'Address'
      end
    end

    test 'co-borrower can registry a new house' do
      WebStub.stub_empty_properties_response
      ChatTokensController.any_instance
                          .stubs(:generate_token)
                          .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
      visit new_co_borrower_rental_path

      image = fixture_file_upload('files/person.jpg', 'image/jpg')
      fill_in 'Address', with: '123 Main street'
      fill_in 'Monthly rent', with: '1000'
      fill_in 'Bedrooms', with: 1
      fill_in 'Bathrooms', with: 1
      attach_file('Picture', image.path, visible: false)
      fill_in 'Phone number', with: '1234567890'
      click_button 'List Rental'

      assert_content 'House successfully registered'
    end
  end
end
