# frozen_string_literal: true

module Customer
  module DashboardHelper
    def message_channel_participants(message_channel)
      participants_emails = message_channel.participants - [current_user.email]

      User.where(email: participants_emails)
    end

    def participants_name(message_channel)
      message_channel_participants(message_channel).map(&:full_name).join(', ')
    end

    def participant_image(message_channel)
      message_channel_participants(message_channel).first.profile_image
    end

    def last_channel_message(message_channel)
      TwilioChatUtils.last_message(message_channel.sid)
    end

    def last_message_hour(channel)
      last_channel_message(channel)&.date_created || Date.current
    end

    def user_id_from_channel(channel)
      user_email = (channel.participants - [current_user.email]).first
      User.find_by(email: user_email)&.id
    end

    def user_step_name(user)
      return t('dashboard.looking_for.loan') if current_user.active_loan_request
      return t('dashboard.looking_for.contact') if user.contact_professional_progress_status == :active
      return t('dashboard.looking_for.friends') if user.friends_progress_status == :active
      return t('dashboard.looking_for.flag') if user.flag_property_progress_status == :active

      t('dashboard.looking_for.joined')
    end

    def user_step_description(user)
      return t('dashboard.looking_for_description.loan') if current_user.active_loan_request
      return t('dashboard.looking_for_description.contact') if user.contact_professional_progress_status == :active
      return t('dashboard.looking_for_description.friends') if user.friends_progress_status == :active
      return t('dashboard.looking_for_description.flag') if user.flag_property_progress_status == :active

      t('dashboard.looking_for_description.joined')
    end

    def suggested_lead_name(user)
      return user.full_name unless user.full_name.length > 12

      "#{user.first_name} #{user.last_name.first}."
    end
  end
end
