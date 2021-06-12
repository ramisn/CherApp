# frozen_string_literal: true

class ProfessionalVerificationMailer < ApplicationMailer
  default from: 'cher@cher.app'

  def send_request(professional_email)
    @professional_email = professional_email
    mail(to: ENV['SUPPORT_MAIL'],
         subject: 'Professional ID verification')
  end
end
