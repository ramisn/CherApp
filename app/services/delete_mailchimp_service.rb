# frozen_string_literal: true

class DeleteMailchimpService
  def process(email)
    list_id = ENV['MAILCHIMP_LIST_ID']

    subscriber_hash = Digest::MD5.hexdigest email.downcase
    $mailchimp.lists.delete_list_member_permanent list_id, subscriber_hash
  rescue StandardError => e
    Raven.capture_exception(e)
    false
  end
end
