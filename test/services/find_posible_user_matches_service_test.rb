# frozen_string_literal: true

require 'test_helper'

class FindPosibleUserMatchesServiceTest < ActiveSupport::TestCase
  setup do
    @user = users(:co_borrower_user)
  end

  test 'it returns only users with all responses' do
    posible_matches = FindPosibleUserMatchesService.new(@user.id).execute

    assert_equal 2, posible_matches.length
    refute posible_matches.include?(users(:co_borrower_user_2))
  end

  test 'it does not return users when they have no responses in valid range' do
    responses(:verified_user_neat_person_response).update!(response: 5)
    posible_matches = FindPosibleUserMatchesService.new(@user.id).execute

    assert_equal 1, posible_matches.length
  end
end
