# frozen_string_literal: true

require 'application_system_test_case'

module Admin
  class RentalsTest < ApplicationSystemTestCase
    setup do
      ChatTokensController.any_instance
                          .stubs(:generate_token)
                          .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    end

    test 'admin can access to rentals index' do
      WebStub.stup_ghost_blog_post
      login_as users(:admin_user)
      visit admin_rentals_path
      assert_content 'Houses for rent'
    end

    test 'admin can see rental house details' do
      WebStub.stup_ghost_blog_post
      login_as users(:admin_user)
      visit admin_rentals_path
      rental = rentals(:co_borrower_rental)
      find("a[href='/admin/rentals/#{rental.id}']").click

      assert_content rental.address
    end

    test 'admin can update a rental' do
      WebStub.stup_ghost_blog_post
      login_as users(:admin_user)
      visit admin_rentals_path
      rental = rentals(:co_borrower_rental)
      find("a[href='/admin/rentals/#{rental.id}']").click

      click_link 'Edit House'
      select 'Approved', from: 'Status'
      click_button 'Update'

      assert_content 'House successfully updated'
    end
  end
end
