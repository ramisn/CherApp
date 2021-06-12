# frozen_string_literal: true

require 'application_system_test_case'

class  PublicationsTest < ApplicationSystemTestCase
  test 'user can like a publication' do
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    WebStub.stub_properties_request
    WebStub.stup_ghost_blog_post
    login_as users(:co_borrower_user)

    visit co_borrower_dashboard_path
    first('button[data-target="likes.likeButton"]').click

    within('ul li.post') do
      assert_content '2'
    end
  end
end
