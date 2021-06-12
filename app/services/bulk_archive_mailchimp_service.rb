# frozen_string_literal: true

class BulkArchiveMailchimpService
  LIST_ID = ENV['MAILCHIMP_LIST_ID']

  def initialize
    @contacts = Contact.in_mailchimp
  end

  def process
    return if @contacts.empty?

    operations = @contacts.map do |user|
      {
        method: 'DELETE',
        path: "/lists/#{LIST_ID}/members/#{Digest::MD5.hexdigest user.email.downcase}",
        operation_id: user.class.name + user.id.to_s
      }
    end

    ops_hash = { operations: operations }
    response = $mailchimp.batches.start ops_hash
    puts response
    update_all
  rescue StandardError => e
    Raven.capture_exception(e)
    false
  end

  def update_all
    @contacts.map(&:mailchimp_removed!)
  end
end
