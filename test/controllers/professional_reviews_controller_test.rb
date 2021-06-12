# frozen_string_literal: true

require 'test_helper'

class ProfessionalReviewsControllerTest < ActionDispatch::IntegrationTest
  test 'it redirects no logged user to new session path' do
    professional = users(:agent_user)

    post customer_professional_reviews_path, params: { professional_review: { reviewed_id: professional.id,
                                                                              comment: 'He did it!',
                                                                              local_knowledge: 1,
                                                                              process_expertise: 1,
                                                                              responsiveness: 1,
                                                                              negotiation_skill: 1 } }
    assert_redirected_to new_user_session_path
  end

  test 'it redirects to root path when reviewing non-revieewable user' do
    coborrower = users(:co_borrower_user_2)
    login_as users(:co_borrower_user)

    post customer_professional_reviews_path, params: { professional_review: { reviewed_id: coborrower.id,
                                                                              comment: 'He did it!',
                                                                              local_knowledge: 1,
                                                                              process_expertise: 1,
                                                                              responsiveness: 1,
                                                                              negotiation_skill: 1 } }
    assert_redirected_to root_path
    assert_equal 'Error creating review', flash[:alert]
  end

  test 'it success requesting for a review creation' do
    professional = users(:agent_user)
    login_as users(:co_borrower_user)

    post customer_professional_reviews_path, params: { professional_review: { reviewed_id: professional.id,
                                                                              comment: 'He did it!',
                                                                              local_knowledge: 1,
                                                                              process_expertise: 1,
                                                                              responsiveness: 1,
                                                                              negotiation_skill: 1 } }
    assert_redirected_to root_path
    assert_equal 'Review sucessfully created', flash[:notice]
  end

  test 'it success updating professional review' do
    review = professional_reviews(:agent_review)
    professional = users(:agent_user)
    login_as users(:co_borrower_user)

    patch customer_professional_review_path(review), params: { professional_review: { reviewed_id: professional.id,
                                                                                      comment: 'He did it!',
                                                                                      local_knowledge: 1,
                                                                                      process_expertise: 1,
                                                                                      responsiveness: 1,
                                                                                      negotiation_skill: 1 } }
    assert_redirected_to root_path
    assert_equal 'Review sucessfully updated', flash[:notice]
  end
end
