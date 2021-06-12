# frozen_string_literal: true

module NewsfeedInteractionHelper
  def button_dislike_post(post)
    content_tag(:button,
                class: 'button m-t-sm is-tag-primary',
                'data-controller': 'likes',
                'data-target': 'likes.likeButton',
                'data-publication-id': post.id,
                'data-likes-number': post.likes.count,
                'data-like-id': user_like(current_user, post).id,
                'data-type': post.class.name.pluralize.downcase,
                'data-is-liked-by-user': 'true',
                'data-action': 'click->likes#updateLike') do
      concat(fa_icon('heart', class: 'm-r-sm'))
      concat(content_tag(:div, 'data-target': 'likes.buttonContent') do
        concat(post.likes.count)
      end)
    end
  end

  def button_like_post(post)
    content_tag(:button,
                class: 'button m-t-sm is-tag-secondary',
                'data-controller': 'likes',
                'data-target': 'likes.likeButton',
                'data-publication-id': post.id,
                'data-likes-number': post.likes.count,
                'data-type': post.class.name.pluralize.downcase,
                'data-action': 'click->likes#updateLike') do
      concat(fa_icon('heart', class: 'm-r-sm'))
      concat(content_tag(:div, 'data-target': 'likes.buttonContent') do
        concat(post.likes.any? ? post.likes.count : 'Likes')
      end)
    end
  end

  def share_button(post)
    post_url = if post.is_a?(Publication)
                 url_for(action: 'show', controller: '/publications', only_path: false, id: post.id)
               else
                 url_for(action: 'show', controller: '/activities', only_path: false, id: post.id)
               end
    content_tag(:button,
                class: 'button m-t-sm m-l-md is-shareable',
                'data-publication-url': post_url,
                'data-action': 'click->share-post#toggleModal share-post#updateModalLinks') do
      concat(image_tag('cherapp-ownership-coborrowing-ico-share.svg', class: 'm-r-sm'))
      concat('Share')
    end
  end

  def user_likes_post?(post, user)
    Like.where(user: user, post: post).exists?
  end

  def user_like(user, post)
    Like.find_by(user: user, post: post)
  end

  def user_posted_in_friend_newsfeed?(post)
    post.owner == current_user && post.recipient
  end

  def someone_posted_in_user_newsfeed?(post)
    post.recipient == current_user
  end

  def user_is_owner_of_post?(post)
    post.owner == current_user
  end
end
