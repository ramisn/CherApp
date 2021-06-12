# frozen_string_literal: true

class CreateContactService
  def process(contact)
    if already_exists?(contact[:email])
      release_token
      return
    end

    Contact.find_or_create_by_prospect(email: contact[:email],
                                       role: role_mapping(contact[:role]),
                                       first_name: contact[:first_name],
                                       city: contact[:city],
                                       status: status_mapping(contact[:role]),
                                       skip_sync: true)
    release_token
  end

  def release_token
    Redis.current.set('sendgrid_token', 0)
  end

  def already_exists?(email)
    Prospect.where(email: email).first || Prospect.where(email: email&.downcase).first
  end

  def status_mapping(role)
    Contact::LETTER_MAPPING[role.scan(/\D/)[0].to_sym]
  end

  def role_mapping(role)
    Prospect::LETTER_MAPPING[role.scan(/\d/).join('').to_sym]
  end
end
