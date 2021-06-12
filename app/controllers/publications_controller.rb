# frozen_string_literal: true

class PublicationsController < AuthenticationsController
  before_action :find_publication, only: %i[update destroy show]

  def new
    @input_id = params[:input_id]
    respond_to do |format|
      format.json do
        render 'new_image_input.html', layout: false
      end
    end
  end

  def create
    publication = current_user.publications.new(publication_params_with_images)
    if publication.save
      flash[:notice] = t('flashes.publications.create.notice')
    else
      flash[:alert] = t('flashes.publications.create.alert')
    end
    redirect_back fallback_location: root_path
  end

  def destroy
    if @publication.destroy
      flash[:notice] = t('flashes.publications.destroy.notice')
    else
      flash[:alert] = t('flashes.publications.destroy.alert')
    end
    redirect_back fallback_location: root_path
  end

  def update
    if @publication.update(publication_params)
      PublicationImagesUpdaterService.new(params).execute
      flash[:notice] = t('flashes.publications.update.notice')
    else
      flash[:alert] = t('flashes.publications.update.alert')
    end
    redirect_back fallback_location: root_path
  end

  def edit
    @publication = Publication.find(params[:id])
    respond_to do |format|
      format.json do
        render 'form.html', layout: false
      end
    end
  end

  def show
    @comment = Comment.new
  end

  private

  def find_publication
    @publication = Publication.find(params[:id])
  end

  def publication_params_with_images
    params.require(:publication)
          .permit(:message, :recipient_id,
                  images: [])
  end

  def publication_params
    params.require(:publication)
          .permit(:message)
  end
end
