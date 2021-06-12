# frozen_string_literal: true

class ImagesController < AuthenticationsController
  def show
    image = ActiveStorage::Attachment.find(params[:id])
    if Rails.env.production? || Rails.env.staging?
      render json: { image_url: image.service_url }
    else
      render json: { image_url: url_for(image) }
    end
  end
end
