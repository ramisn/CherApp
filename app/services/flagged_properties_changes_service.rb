# frozen_string_literal: true

class FlaggedPropertiesChangesService
  def execute
    User.kept.co_borrower.each { |user| send_emails(user) }
  end

  private

  def send_email(user)
    property = property_changed(user)
    return if property.blank?

    update_property(property) # We need to update the data to keep the changes
    UsersMailer.notify_property_changed(user).deliver_now
  end

  def property_changed(user)
    user.flagged_properties.detect { |property| !property.price_difference.zero? || property.status_changed? }
  end

  def update_propeproperty(property)
    property.update(price_on_flag: property.current_price,
                    status_on_flag: property.current_status)
  end
end
