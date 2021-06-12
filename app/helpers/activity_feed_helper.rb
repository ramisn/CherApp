# frozen_string_literal: true

module ActivityFeedHelper
  LINK = { 'flagged_property.destroy': 'activity_destroy',
           'flagged_property.create': 'activity_destroy',
           'friend_request.create': 'activity_friend',
           'friend_request.accepted': 'activity_friend',
           'message_channel.create': 'activity_channel',
           'message_channel.received': 'activity_channel',
           'user.search_city': 'activity_search',
           'user.create': 'activity_welcome',
           'post.create': 'activity_post',
           'user.referred': 'activity_referred_user' }.freeze

  def activity_message(activity)
    action = LINK[activity.key.to_sym]
    return unless action

    send(action.to_sym, activity)
  end

  def activity_destroy(activity)
    if activity.owner_id != current_user.id
      translation = t("feed.#{activity.key}_friend")
      user_link = friend_request_link(activity.owner)
    end
    formated_message(activity, element_link: watch_property_link(activity), translation: translation, user_link: user_link)
  end

  def activity_friend(activity)
    profile_image = profile_picture_tag(activity.recipient.profile_image)

    translation = friend_request_transalation(activity)
    formated_message(activity, element_link: friend_request_link(activity.recipient), profile_image: profile_image, translation: translation)
  end

  def activity_channel(activity)
    translation = t('feed.message_channel.received') if activity.recipient_id == current_user.id
    formated_message(activity, element_link: channel_link(activity), translation: translation)
  end

  def activity_referred_user(activity)
    if activity.owner_id == current_user.id
      build_referred_user_activity(activity)
    else
      build_referrer_user_activity(activity)
    end
  end

  def build_referred_user_activity(activity)
    translation = t('feed.user.you_were_referred')
    link = link_to(activity.recipient.first_name || activity.recipient.email, user_path(activity.recipient))
    profile_image = profile_picture_tag(activity.recipient.profile_image)
    formated_message(activity, element_link: link, profile_image: profile_image, translation: translation)
  end

  def build_referrer_user_activity(activity)
    return unless activity.owner

    translation = t('feed.user.you_referred')
    link = link_to(activity.owner.first_name || activity.owner.email, user_path(activity.owner))
    profile_image = profile_picture_tag(activity.owner.profile_image)
    formated_message(activity, element_link: link, profile_image: profile_image, translation: translation)
  end

  def activity_search(activity)
    formated_message(activity, element_link: search_link(activity))
  end

  def activity_post(activity)
    formated_message(activity, element_link: create_post_link(activity))
  end

  def activity_welcome(activity)
    formated_message(activity)
  end

  def profile_picture_tag(image)
    image_tag(image, alt: t('img_alts.user_profile'), class: 'profile-picture',
                     'data-controller': 'users-profile-picture',
                     'data-action': 'error->users-profile-picture#setDefaultPicture')
  end

  def friend_request_transalation(activity)
    if activity.key == 'friend_request.accepted'
      if activity.owner_id != current_user.id
        t('feed.friend_request.responded')
      else
        t('feed.friend_request.accepted')
      end
    elsif activity.owner_id != current_user.id
      t('feed.friend_request.received')
    end
  end

  def formated_message(activity, options = {})
    content_tag :div, class: '' do
      concat(options[:user_link])
      concat(content_tag(:span, options[:translation] || t("feed.#{activity.key}")))
      concat(options[:element_link])
      concat(record_formated_date(activity))
      concat(options[:profile_image])
      interactive_options(activity)
    end
  end

  def interactive_options(activity)
    if user_likes_post?(activity, current_user)
      concat(button_dislike_post(activity))
    else
      concat(button_like_post(activity))
    end
    concat(share_button(activity))
  end

  def create_post_link(activity)
    link_to(activity.parameters['title'],
            "#{ENV['BLOG_URL']}/#{activity.parameters['slug']}",
            target: '_blank', class: 'gtm-track-click',
            'gtm-label': 'News Feed Click - Blog',
            'gtm-value': activity.parameters['title'])
  end

  def search_link(activity)
    link_to(activity.parameters['cities'],
            look_around_path(city: activity.parameters['cities']),
            target: '_blank', class: 'gtm-track-click',
            'gtm-label': 'News Feed Click - Search Link',
            'gtm-value': activity.parameters['cities'])
  end

  def watch_property_link(activity)
    link_to('View details',
            property_path(activity.parameters['property_id']),
            target: '_blank', class: 'gtm-track-click',
            'gtm-label': 'News Feed Click - Property Details',
            'gtm-value': activity.parameters['property_id'])
  end

  def channel_link(activity)
    link_to(activity.recipient.full_name,
            user_path(activity.recipient),
            target: '_blank', class: 'gtm-track-click',
            'gtm-label': 'News Feed Click - Message Channel',
            'gtm-value': activity.recipient.full_name)
  end

  def friend_request_link(user)
    link_to(user.full_name, user_path(user),
            target: '_blank', class: 'gtm-track-click',
            'gtm-label': 'News Feed Click - Friend Request',
            'gtm-value': user.full_name)
  end

  def record_formated_date(activity)
    content_tag(:em, activity.created_at.strftime('%B %d, %Y'))
  end
end
