# frozen_string_literal: true

class SendConfirmationEmailService
  def self.call(*args, &block)
    new(*args, &block).execute
  end

  def initialize(dynamic_template_data, destinatary)
    @subject = 'Confirmation email'
    @template_id = ENV['SENDGRID_COMPLETE_PROFILE_TEMPLATE_ID']
    @dynamic_template_data = dynamic_template_data
    @destinatary = destinatary
    @sender = { name: 'Cher', email: ENV['SENDGRID_CHER_EMAIL'] }
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
