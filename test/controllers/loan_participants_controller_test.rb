# frozen_string_literal: true

require 'test_helper'

class LoanParticipantsControllerTest < ActionDispatch::IntegrationTest
  test 'it redirects to root path when bad token given' do
    participant = loan_participants(:user_without_role_participant)

    get edit_loan_participant_path(participant, token: 'badtoken-here')

    assert_redirected_to root_path
  end

  test 'it success accessing to edit' do
    participant = loan_participants(:user_without_role_participant)

    get edit_loan_participant_path(participant, token: participant.token)

    assert_response :success
  end

  test 'it success updating participant status' do
    participant = loan_participants(:user_without_role_participant)

    put loan_participant_path(participant, token: participant.token, participant: { accepted_request: true })

    assert_equal 'Loan process successfully accepted', flash[:notice]
  end

  test 'it updates loan status when last participant accept request' do
    participant = loan_participants(:user_without_role_participant)

    put loan_participant_path(participant, token: participant.token, participant: { accepted_request: true })

    assert participant.loan.active?
  end

  test 'an email is sent once last participant approved request' do
    participant = loan_participants(:user_without_role_participant)

    put loan_participant_path(participant, token: participant.token, participant: { accepted_request: true })

    assert participant.loan.active?
    assert_enqueued_emails 1
  end
end
