# frozen_string_literal: true

class LikesController < AuthenticationsController
  before_action :find_post

  def create
    like = @post.likes.find_or_initialize_by(like_params)
    if like.save
      render json: { like: like, errors: @post.errors }, status: 200
    else
      render json: { liek: like, errors: @post.errors }, status: 422
    end
  end

  def destroy
    like = @post.likes.find(params[:id])
    if like.destroy
      render json: { errors: @post.errors }, status: 200
    else
      render json: { errors: @post.errors }, status: 422
    end
  end

  private

  def find_post
    if params[:comment_id]
      @post = Comment.find(params[:comment_id])
    elsif params[:publication_id]
      @post = Publication.find(params[:publication_id])
    elsif params[:activity_id]
      @post = Activity.find(params[:activity_id])
    end
  end

  def like_params
    { user: current_user }
  end
end
