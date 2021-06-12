# frozen_string_literal: true

class BlurImageJob < ActiveJob::Base
  queue_as :default

  def initialize(image_path, user_id)
    @user_id = user_id
    @image_path = image_path
  end

  def perform
    blurred_image = BlurImageService.new(image_path).blur_image
    return unless blurred_image

    user.blurred_image.attach(io: blurred_image, filename: 'blurred_image.jpg', content_type: 'image/jpg')
  end

  private

  attr_reader :user_id, :image_path

  def user
    @user ||= User.find(user_id)
  end
end
