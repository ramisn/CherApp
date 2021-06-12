# frozen_string_literal: true

class SendgridEventFactory
  def initialize(events)
    @events = events
  end

  def register
    # TODO: Move to background job
    @events.each do |event_data|
      event = event_data['event']
      email = event_data['email']
      next unless event.present? && email.present?

      titleized_event = event.downcase.gsub(' ', '')
      next unless Contact.statuses.keys.include? titleized_event

      contact = Contact.lookup(email)
      next unless contact.present?

      contact.send(:"#{titleized_event}!")

      UpdateSendgridJob.perform_later(email, :unsubscribe) if Contact::UNSUBSCRIBE_EVENTS.include? titleized_event.to_sym
    end
  end
end
