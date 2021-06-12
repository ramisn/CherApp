# frozen_string_literal: true

require 'test_helper'

class CoBorrower::LoansControllerTest < ActionDispatch::IntegrationTest
  setup do
    WebStub.stub_properties_request
  end

  test 'it redirect no logged users to new session path' do
    get new_co_borrower_loan_path

    assert_redirected_to new_user_session_path
    assert_equal 'You need to sign in or sign up before continuing.', flash[:alert]
  end

  test 'it redirect no coborrower users to landing page' do
    login_as users(:agent_user)

    get new_co_borrower_loan_path

    assert_redirected_to root_path
    assert_equal 'You cannot access this section.', flash[:alert]
  end

  test 'it success when coborrower request for new loan' do
    login_as users(:co_borrower_user_2)

    get new_co_borrower_loan_path

    assert :success
  end

  test 'it success creating a loan' do
    participant = users(:co_borrower_user)
    login_as users(:co_borrower_user_2)

    post co_borrower_loans_path, params: { loan: { property_street: '123 Main street Santa Monica',
                                                   property_id: '123asd',
                                                   participants_attributes: [{ user_id: participant.id }],
                                                   first_home: false,
                                                   live_there: false } }

    assert_redirected_to co_borrower_loan_path(Loan.last, process_finished: true)
    assert_equal 'Loan successfully saved', flash[:notice]
  end

  test 'it render new template when error saving loan' do
    login_as users(:co_borrower_user_2)

    post co_borrower_loans_path, params: { loan: { property_id: '123asd', participants_ids: [] } }

    assert_template :new
    assert_equal 'Error saving loan', flash[:alert]
  end

  test 'it success rendering a loan request' do
    login_as users(:co_borrower_user)

    get co_borrower_loan_path(loans(:co_borrower_loan))

    assert_response :success
    assert_template :show
  end
end
