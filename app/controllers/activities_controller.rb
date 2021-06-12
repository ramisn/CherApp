# frozen_string_literal: true

class ActivitiesController < AuthenticationsController
  def destroy
    @activity = Activity.find_by(id: params[:id], owner: current_user)
    if @activity.destroy
      flash[:notice] = t('flashes.activities.delete.notice')
    else
      flash[:alert] = t('flashes.activities.delete.alert')
    end
    redirect_back fallback_location: root_path
  end

  def show
    @activity = Activity.find(params[:id])
    @comment = Comment.new
  end
end
