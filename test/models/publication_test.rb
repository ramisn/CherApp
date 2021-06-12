# frozen_string_literal: true

# == Schema Information
#
# Table name: publications
#
#  id               :bigint           not null, primary key
#  owner_id         :bigint
#  message          :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  recipient_id     :bigint
#  publication_type :integer
#  link             :string
#  params           :jsonb
#
require 'test_helper'

class PublicationTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  test 'it is not valid without a owner' do
    publication = Publication.new(message: 'Lokin for a pretty house')

    refute publication.valid?
  end

  test 'it is not valid without a message nor a image' do
    publication = Publication.new(owner: users(:co_borrower_user))

    refute publication.valid?
  end

  test 'it is not valid when owner is same as recipient' do
    publication = Publication.new(owner: users(:co_borrower_user),
                                  recipient: users(:co_borrower_user),
                                  message: 'Lokin for a pretty house')

    refute publication.valid?
    assert_equal 'You can not publish to your own profile', publication.errors[:recipient].first
  end

  test 'it is valid with an image and owner' do
    image = fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'person.jpg'), 'image/jpg')
    publication = Publication.new(owner: users(:co_borrower_user),
                                  images: image,
                                  message: 'Looking for a really cool house')

    assert publication.valid?
  end

  test 'it is valid with message and owner' do
    publication = Publication.new(owner: users(:co_borrower_user),
                                  message: 'Looking for a really cool house')

    assert publication.valid?
  end

  test 'it is valid with all attributes' do
    image = fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'person.jpg'), 'image/jpg')
    publication = Publication.new(owner: users(:co_borrower_user),
                                  images: image,
                                  recipient: users(:agent_user),
                                  message: 'Looking for a pretty house')

    assert publication.valid?
  end
end
