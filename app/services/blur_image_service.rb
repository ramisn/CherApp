# frozen_string_literal: true

require 'image_processing/mini_magick'

class BlurImageService
  def initialize(image_path)
    @image_path = image_path
  end

  def blur_image
    processor.blur('0x30').call
  rescue MiniMagick::Error => e
    Rails.logger.debug "Fatal error blurring image: #{e.message}, image_path: #{@image_path}"
    nil
  end

  private

  def processor
    ImageProcessing::MiniMagick.source(fetch_image)
  end

  def fetch_image
    Rails.env.production? || Rails.env.staging? ? URI.parse(@image_path.service_url).open : ActiveStorage::Blob.service.path_for(@image_path.key)
  rescue NoMethodError
    @image_path
  end
end
