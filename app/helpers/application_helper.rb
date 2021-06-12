# frozen_string_literal: true

module ApplicationHelper
  TEAM_MEBERS_EMAIL = ['eric@cher.app', 
                      'paul@cher.app', 
                      'russell@cher.app', 
                      'Matt@cher.app',
                      'henry@cher.app',
                      'nathan@cher.app',
                      'tyler@cher.app',
                      'ebrenner@cher.app'].freeze
  def am_pm_select_hour(name, *args, &block)
    Cher::CustomDateTime.new(name, *args, &block).select_hour
  end

  def meta_tag(tag, text)
    content_for :"meta_#{tag}", text
  end

  def response_id(live_factor)
    @user_responses ||= current_user.responses
    @user_responses.find_by(live_factor: live_factor)&.id
  end

  def title(text)
    content_for :title, text
  end

  def property_location_addres1(property_address)
    "#{property_address['streetNumber']} #{property_address['streetName']}"
  end

  def property_location_city(property_address)
    "#{property_address['city']} "
  end

  def property_location_state_and_zip(property_address)
    "#{property_address['state']} #{property_address['postalCode']} "
  end

  def users_are_friends?(user_id)
    FriendRequest.users_are_friends?(current_user.id, user_id)
  end

  def user_select_option(live_factor, index)
    current_user.responses
                .find_by(live_factor: live_factor)&.response.to_i == index
  end

  def user_can_receive_review?(user)
    user.agent? && user.id != current_user.id
  end

  def yield_meta_tag(tag, default_text = '')
    content_for?(:"meta_#{tag}") ? content_for(:"meta_#{tag}") : default_text
  end

  def user_can_delete_activity?(post)
    post.owner_id == current_user.id || post.recipient_id == current_user.id
  end

  def formated_phone_number(phone_number)
    match = phone_number.match(/^(\d{3})(\d{3})(\d{4})$/)
    "(#{match[1]})#{match[2]}-#{match[3]}"
  end

  def parse_date_time(date)
    DateTime.parse(date).strftime('%B %d, %Y - %l:%M %P')
  end

  def random_cher_team_member
    cher_team_users.sample
  end

  def cher_team_users
    @cher_team_users ||= User.where(email: TEAM_MEBERS_EMAIL)
  end

  def formated_hour(datetime)
    if datetime.to_date < Date.today
      distance_of_time_in_words(datetime, Time.now, scope: 'datetime.distance_in_words.only_hour')
    else
      datetime.strftime('%l:%M %p')
    end
  end

  def user_image(user)
    return user.image unless user.image_stored.attached?

    if Rails.env.production? || Rails.env.staging?
      user.image_stored.service_url
    else
      rails_blob_path(user.image_stored, disposition: 'attachment', only_path: true)
    end
  end

  def user_is_in_conversation?
    params[:controller] == 'users/conversations' && params[:action] == 'show'
  end

  def user_is_in_conversation_list?
    params[:controller] == 'users/conversations' && params[:action] == 'index'
  end
end
