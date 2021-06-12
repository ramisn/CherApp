# frozen_string_literal: true

class ProfessionalContactChannelUpdaterService
  def initialize(channel, current_user)
    coowner_email = channel.participants.reject { |email| email == current_user.email }
    @coowner = User.find_by(email: coowner_email)
  end

  def execute
    channels = MessageChannel.where("participants @> ARRAY[?]::varchar[] AND purpose = 'professional_support'", @coowner.email)
    channels.update_all(status: :closed)
    @coowner.update(contact_professional: true)
  end
end
