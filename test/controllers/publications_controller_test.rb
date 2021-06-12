# frozen_string_literal: true

require 'test_helper'

class PublicationsControllerTest < ActionDispatch::IntegrationTest
  test 'it redirect no logged user to new session path' do
    post publications_path, params: { publication: { message: 'Who wants to co-own with me?' } }

    assert_redirected_to new_user_session_path
  end

  test 'it success requesting for new publication creation' do
    login_as users(:co_borrower_user)
    image = fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'person.jpg'), 'image/jpg')

    assert_difference 'publication = Publication.count', 1 do
      post publications_path, params: { publication: { message: 'Who wants to co-own with me?', inmage: image } }
    end
  end

  test 'it success requestin for update publication' do
    login_as users(:co_borrower_user)
    publication = publications(:co_borrower_home)

    put publication_path(publication), params: { publication: { message: 'Who would like to co-own with me?' } }

    publication.reload
    assert_equal 'Who would like to co-own with me?', publication.message
  end

  test 'it success requestion for publication deletion' do
    login_as users(:co_borrower_user)
    publication = publications(:co_borrower_home)

    assert_difference 'Publication.count', -1 do
      delete publication_path(publication)
    end
  end

  test 'it success when reqeusting for new publication' do
    login_as users(:co_borrower_user)

    get new_publication_path, params: { format: :json }

    assert_response :success
  end

  test 'it success when reqeusting for edit publication' do
    login_as users(:co_borrower_user)
    publication = publications(:co_borrower_home)

    get edit_publication_path(publication), params: { format: :json }

    assert_response :success
  end
end
