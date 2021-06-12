# frozen_string_literal: true

class FriendsRequestsSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :requester

  def requester
    { full_name: object.requester.full_name,
      profile_image: profile_image,
      email: object.requester.email }
  end

  def profile_image
    user = object.requester
    return user.image unless user.image_stored.attached?

    Rails.env.production? || Rails.env.staging? ? user.image_stored.service_url : ActiveStorage::Blob.service.path_for(user.image_stored.key)
  end
end
