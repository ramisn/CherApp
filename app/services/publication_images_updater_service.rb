# frozen_string_literal: true

class PublicationImagesUpdaterService
  def initialize(params)
    @publication = Publication.find(params[:id])
    @images = params[:publication][:images]
    @images_marked_for_destruction = params[:images_marked_for_destruction]
  end

  def execute
    @publication.images.attach(@images) unless @images.blank?
    @images_marked_for_destruction&.each do |image_id|
      next if image_id.blank?

      @publication.images.find(image_id).purge_later
    end
  end
end
