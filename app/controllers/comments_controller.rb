# frozen_string_literal: true

class CommentsController < AuthenticationsController
  before_action :find_publication
  before_action :find_comment, only: %i[destroy edit update]

  def create
    comment = @post.comments.new(comment_params)
    if comment.save
      flash[:notice] = t('flashes.comments.create.notice')
    else
      flash[:alert] = t('flashes.comments.create.alert')
    end
    redirect_back fallback_location: root_path
  end

  def destroy
    if @comment.destroy
      flash[:notice] = t('flashes.comments.destroy.notice')
    else
      flash[:alert] = t('flashes.comments.destroy.alert')
    end
    redirect_back fallback_location: root_path
  end

  def edit
    respond_to do |format|
      format.json { render 'edit.html', layout: false }
    end
  end

  def update
    if @comment.update(comment_params)
      flash[:notice] = t('flashes.comments.update.notice')
    else
      flash[:alert] = t('flashes.comments.update.alert')
    end
    redirect_back fallback_location: root_path
  end

  private

  def comment_params
    params.require(:comment)
          .permit(:body)
          .merge(owner: current_user)
  end

  def find_comment
    @comment = @post.comments.find(params[:id])
  end

  def find_publication
    if params[:publication_id]
      @post = Publication.find(params[:publication_id])
    elsif params[:activity_id]
      @post = Activity.find(params[:activity_id])
    end
  end
end
