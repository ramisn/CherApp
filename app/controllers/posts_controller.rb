# frozen_string_literal: true

class PostsController < ApplicationController
  protect_from_forgery except: :create

  def create
    post = Post.find_or_initialize_by(uuid: post_params[:current][:uuid])
    post.update_attributes(current_post_params)
    post.create_activity(:create, parameters: current_post_params) if post.save
  end

  private

  def post_params
    params.require(:post).permit(current: {}, previous: {})
  end

  def current_post_params
    post_params[:current].slice(:title, :slug, :feature_image, :plaintext)
  end
end
