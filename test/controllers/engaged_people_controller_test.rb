# frozen_string_literal: true

require 'test_helper'

class EngagedPeopleControllerTest < ActionDispatch::IntegrationTest
  setup do
    @co_borrower_user = users(:verified_user)
    @flagged_property = flagged_properties(:flagged_property)
  end

  test 'it returns a list of people with same properties interest' do
    login_as @co_borrower_user
    get engaged_people_path, params: { property_id: 'ASDF1234' }

    assert_response :success
    assert_equal 2, assigns[:engaged_people].count
    assert_equal 'borrower@user.com', assigns[:engaged_people].last.email
  end
end
