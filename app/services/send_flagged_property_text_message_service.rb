# frozen_string_literal: true

class SendFlaggedPropertyTextMessageService
  def initialize(current_user, property_id, property)
    @property_id = property_id
    @property = property
    @current_user = current_user
  end

  def execute
    @current_user.friends.each do |friend|
      next unless friend.phone_number

      message = I18n.t('sms_notifications.flagged_home', translate_params(friend))
      SendSmsService.new(message, friend.phone_number, sms_type: :flagged_home).execute unless friend.phone_number.blank?
    end
  end

  private

  def translate_params(friend)
    here_link = BitlyClient.short_url("#{ENV['APP_URL']}/properties/#{@property_id}")

    { friend_name: friend.first_name, friend_last_name: friend.last_name,
      user_name: @current_user.full_name, city: @property['city'],
      address: "#{@property['streetNumber']} #{@property['streetName']}", here_link: here_link }
  end

  def sender
    @current_user.full_name.blank? ? I18n.t('generic.a_friend') : @current_user.full_name
  end
end
