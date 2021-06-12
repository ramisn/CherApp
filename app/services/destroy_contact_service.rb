# frozen_string_literal: true

class DestroyContactService
  def initialize(contact_id)
    @contact = Contact.find(contact_id)
  end

  def execute
    send("delete_#{@contact.contactable_type.downcase}")
  end

  private

  def delete_user
    user = @contact.contactable

    Contact.transaction do
      @contact.discard
      user.discard

      UserAccountMailer.with(user: user).delete_account.deliver_later
      Clique::DeleteSubscriptionService.new(user).execute if user.agent?
    end
  end

  def delete_prospect
    Contact.transaction do
      @contact.contactable.discard
      @contact.discard
    end
  end
end
