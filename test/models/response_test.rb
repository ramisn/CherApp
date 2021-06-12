# frozen_string_literal: true

# == Schema Information
#
# Table name: responses
#
#  id             :integer          not null, primary key
#  user_id        :integer          not null
#  live_factor_id :integer          not null
#  response       :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class ResponseTest < ActiveSupport::TestCase
  test 'response record is not valid with no user relation' do
    response = Response.new(live_factor: live_factors(:neat_person),
                            response: 0)

    refute response.valid?
  end

  test 'response record is not valid with no live factor relation' do
    response = Response.new(user: users(:co_borrower_user),
                            response: 0)

    refute response.valid?
  end

  test 'response record is not valid with no response' do
    response = Response.new(live_factor: live_factors(:neat_person),
                            user: users(:co_borrower_user))

    refute response.valid?
  end

  test 'response record is valid with user, live factor and response attributes' do
    response = Response.new(live_factor: live_factors(:neat_person),
                            user: users(:co_borrower_user),
                            response: 0)

    assert response.valid?
  end
end
