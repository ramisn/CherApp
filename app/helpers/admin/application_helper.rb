# frozen_string_literal: true

module Admin
  module ApplicationHelper
    def prospect_is_also_user?(email)
      user = User.find_by(email: email)
      user&.role
    end

    def user_role(email)
      user = User.find_by(email: email)
      user.role
    end

    def contact_role_translation(subfilter, filter = nil)
      if filter
        t("admin.contacts.key_#{subfilter}", key: Contact::LETTER_MAPPING.key(filter.to_sym))
      else
        t("admin.contacts.#{subfilter}")
      end
    end
  end
end
