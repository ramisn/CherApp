# frozen_string_literal: true

require 'test_helper'

class ProfessionalReviewTest < ActiveSupport::TestCase
  def setup
    reviewer_user = users(:co_borrower_user)
    reviewed_user = users(:agent_user)
    @review = ProfessionalReview.new(reviewer: reviewer_user,
                                     reviewed: reviewed_user,
                                     comment: 'He did it!',
                                     local_knowledge: 1,
                                     process_expertise: 1,
                                     responsiveness: 1,
                                     negotiation_skills: 1)
  end

  test 'it is not valid without a reviewer' do
    @review.reviewer = nil

    refute @review.valid?
  end

  test 'it is not valid without a reviewed' do
    @review.reviewed = nil

    refute @review.valid?
  end

  test 'it is not valid without local knowledge' do
    @review.local_knowledge = nil

    refute @review.valid?
  end

  test 'it is not valid without process expertise' do
    @review.process_expertise = nil

    refute @review.valid?
  end

  test 'it is not valid without responsiveness' do
    @review.responsiveness = nil

    refute @review.valid?
  end

  test 'i ti not valid without negotiation skill' do
    @review.negotiation_skills = nil

    refute @review.valid?
  end

  test 'it is not valid with local knowledge biggert than 5' do
    @review.local_knowledge = 6

    refute @review.valid?
  end

  test 'it is not valid with local knowledge smaller than 0' do
    @review.local_knowledge = -1

    refute @review.valid?
  end

  test 'it is not valid with process expertise bigger than 5' do
    @review.process_expertise = 6

    refute @review.valid?
  end

  test 'it is not valid with process expertise smaller than 0' do
    @review.process_expertise = -1

    refute @review.valid?
  end

  test 'it is not valid with responsiveness bigger than 5' do
    @review.responsiveness = 6

    refute @review.valid?
  end

  test 'it is not valid with responsiveness smaller than 0' do
    @review.responsiveness = -1

    refute @review.valid?
  end

  test 'it is not valid with negotiation skill bigger than 5' do
    @review.negotiation_skills = 6

    refute @review.valid?
  end

  test 'it is not valid with negotiation skill smaller than 0' do
    @review.negotiation_skills = -11

    refute @review.valid?
  end

  test 'it is not valid with reviwer and reviewed beign same person' do
    reviewed_user = users(:agent_user)
    @review.reviewer = reviewed_user

    refute @review.valid?
  end

  test 'it is valid with all attributes' do
    assert @review.valid?
  end
end
