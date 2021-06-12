# frozen_string_literal: true

require 'application_system_test_case'

module Admin
  class ProspectsTest < ApplicationSystemTestCase
    setup do
      ChatTokensController.any_instance
                          .stubs(:generate_token)
                          .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
      WebStub.stup_ghost_blog_post
      login_as users(:admin_user)
      visit root_path
      page.execute_script 'window.scrollBy(0,10000)'
    end

    test 'admin can access to prospects' do
      find('.go-profile').hover
      click_link('Contacts')

      assert page.has_content?('Contacts')
    end

    test 'admin upload a csv with prospects' do
      WebStub.stub_sendgrid_contacts
      prospects_csv = fixture_file_upload('files/prospects.csv', 'text/csv')

      visit admin_contacts_path
      find('img[alt="Upload file"]').click
      attach_file('contact[file]', prospects_csv.path, visible: false)
      click_button('Upload')

      assert_content 'Prospects uploaded successfully'
    end
  end
end
