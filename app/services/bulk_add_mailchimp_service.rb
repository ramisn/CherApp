# frozen_string_literal: true

class BulkAddMailchimpService
  LIST_ID = ENV['MAILCHIMP_LIST_ID']

  def initialize(conditions)
    @conditions = conditions
  end

  def process
    operations = contacts.map do |user|
      build_op user
    end

    ops_hash = { operations: operations }
    response = $mailchimp.batches.start ops_hash
    puts response

    update_all
  rescue StandardError => e
    Raven.capture_exception(e)
    false
  end

  def contacts
    contacts = []
    @conditions.each do |condition|
      contacts |= Contact.by_type(condition.scan(/\d.*/)[0])
    end
    contacts
  end

  def update_all
    contacts.map(&:mailchimp_updated!)
  end

  def build_op(user)
    {
      method: 'POST',
      path: "/lists/#{LIST_ID}/members",
      operation_id: user.class.name + user.id.to_s,
      body: {
        email_address: user.email,
        status: 'subscribed'
      }.to_json
    }
  end
end
