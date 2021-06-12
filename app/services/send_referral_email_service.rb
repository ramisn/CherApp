# frozen_string_literal: true

class SendReferralEmailService
  def initialize(invited_user, token)
    @subject = '$500 for you and $500 for you friend'
    @template_id = ENV['SENDGRID_REFERRAL_TEMPLATE_ID']
    @dynamic_template_data = { link: "#{ENV['APP_URL']}/users/invitation/accept?invitation_token=#{token}",
                               friend_email: invited_user.invited_by.email }
    @sender = { name: invited_user.invited_by.full_name, email: invited_user.invited_by.email }
    @destinatary = {  email: invited_user.email }
  end

  def execute
    Sendgrid::TransactionalMailer.new(sender: @sender,
                                      subject: @subject,
                                      template_id: @template_id,
                                      dynamic_template_data: @dynamic_template_data,
                                      destinatary: @destinatary)
                                 .send_message!
  end
end
