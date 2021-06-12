# frozen_string_literal: true

require 'application_system_test_case'

class ReviewsTest < ApplicationSystemTestCase
  def setup
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    login_as users(:co_borrower_user)
    agent = users(:agent_user)
    visit user_path(agent)
  end

  test 'user can write a review' do
    click_button 'Write a review'
    find('label[for="local_knowledge_2_"]').click
    find('label[for="process_expertise_3_"]').click
    find('label[for="responsiveness_2_"]').click
    find('label[for="negotiation_skills_4_"]').click
    click_button 'Submit'

    assert_content 'Review sucessfully created'
  end

  test 'user can write a review with comments and title' do
    click_button 'Write a review'
    find('label[for="local_knowledge_2_"]').click
    find('label[for="process_expertise_3_"]').click
    find('label[for="responsiveness_2_"]').click
    find('label[for="negotiation_skills_4_"]').click
    fill_in 'professional_review_title', with: 'He just did it!'
    fill_in 'Comment', with: 'ut perspiciatis unde omnis iste natus'
    click_button 'Submit'

    assert_content 'Review sucessfully created'
  end

  test 'user can edit given review' do
    click_button 'Edit review'
    fill_in 'professional_review_title', with: 'He just did it again!'
    click_button 'Submit'

    assert_content 'Review sucessfully updated'
    assert_content 'He just did it again!'
  end
end
