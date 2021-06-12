# frozen_string_literal: true

class UsersSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :email, :full_name, :profile_image, :are_friends, :friend_request_status,
             :images, :first_name, :last_name, :part_of_clique?, :slug, :role, :full_name, :phone_number, :recently_active?

  def profile_image
    return object.image unless object.image_stored.attached? && scope

    if Rails.env.production? || Rails.env.staging?
      object.image_stored.service_url
    else
      rails_blob_path(object.image_stored, disposition: 'attachment', only_path: true)
    end
  end

  def are_friends
    scope ? FriendRequest.users_are_friends?(scope.id, object.id) : false
  end

  def friend_request_status
    scope ? FriendRequest.request_status(scope.id, object.id) : nil
  end

  def images
    return [] unless object.images.attachments && scope

    object.images.map do |image|
      image_path = if Rails.env.production? || Rails.env.staging?
                     image.service_url
                   else
                     rails_blob_path(image, disposition: 'attachment', only_path: true)
                   end
      { id: image.id, url: image_path }
    end
  end
end
