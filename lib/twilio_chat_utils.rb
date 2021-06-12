# frozen_string_literal: true

class TwilioChatUtils
  ACCOUNT_SID = ENV['TWILIO_ACCOUNT_SID']
  TWILIO_AUTH_TOKEN = ENV['TWILIO_AUTH_TOKEN']
  SERVICE_SID = ENV['TWILIO_SERVICE_SID']
  CHANNEL_ADMIN_ROLE_SID = ENV['TWILIO_CHANNEL_ADMIN_ROLE_SID']

  def self.create_channel(creator_email, channel_attributes, options = {})
    client.chat
          .services(SERVICE_SID)
          .channels
          .create(created_by: creator_email, attributes: channel_attributes, **options)
  end

  def self.delete_channel(channel_sid)
    client.chat
          .services(SERVICE_SID)
          .channels(channel_sid)
          .delete
  end

  def self.invite_user_to_channel(user_email, channel_sid)
    client.chat
          .services(SERVICE_SID)
          .channels(channel_sid)
          .invites
          .create(identity: user_email)
  end

  # More details about available and default roles
  # https://www.twilio.com/console/chat/services/[SERVICE_ID]/roles
  def self.join_user_to_channel(user_email, channel_sid, admin: false)
    member_attributes = { identity: user_email }
    member_attributes.merge!(role_sid: CHANNEL_ADMIN_ROLE_SID) if admin
    client.chat
          .services(SERVICE_SID)
          .channels(channel_sid)
          .members
          .create(member_attributes)
  end

  def self.remove_user_from_channel(user_email, channel_sid)
    client.chat
          .services(SERVICE_SID)
          .channels(channel_sid)
          .members(user_email)
          .delete
  end

  def self.create_user(email)
    client.chat
          .services(SERVICE_SID)
          .users
          .create(identity: email)
  rescue Twilio::REST::RestError => _e
    false
  end

  def self.send_message(message, user, channel_sid)
    client.chat
          .services(SERVICE_SID)
          .channels(channel_sid)
          .messages
          .create(from: user, body: message)
  end

  def self.last_message(channel_sid)
    client.chat
          .services(SERVICE_SID)
          .channels(channel_sid)
          .messages
          .list(limit: 1, order: :desc)
          .first
  end

  def self.client
    @client ||= Twilio::REST::Client.new(ACCOUNT_SID, TWILIO_AUTH_TOKEN)
  end

  # Available member permissions
  # https://www.twilio.com/docs/chat/permissions
  def self.member_permissions(channel_sid, user_identity)
    member = client.chat
                   .services(SERVICE_SID)
                   .channels(channel_sid)
                   .members(user_identity)
                   .fetch
    client.chat
          .services(SERVICE_SID)
          .roles(member.role_sid)
          .fetch
          .permissions
  rescue Twilio::REST::RestError => _e
    []
  end

  def self.channel_exists?(channel_sid)
    client.chat
          .services(SERVICE_SID)
          .channels(channel_sid)
          .fetch
  rescue Twilio::REST::RestError => _e
    false
  end

  def self.update_channel(channel_sid, attributes)
    client.chat
          .services(SERVICE_SID)
          .channels(channel_sid)
          .update(**attributes)
  end
end
