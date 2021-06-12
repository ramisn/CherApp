# frozen_string_literal: true

class UserImagesController < AuthenticationsController
  def create
    respond_to do |format|
      format.json do
        if current_user.images.attach(user_gallery_params[:image])
          render json: UsersSerializer.new(current_user, scope: current_user).as_json
        else
          render json: UsersSerializer.new(current_user, scope: current_user).as_json, status: 400
        end
      end
    end
  end

  def destroy
    image = ActiveStorage::Blob.find(params[:id])
    image.attachments.first.purge
    render json: UsersSerializer.new(current_user, scope: current_user).as_json
  end

  private

  def user_gallery_params
    params.require(:user).permit(:image)
  end
end
