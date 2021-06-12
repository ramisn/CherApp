# frozen_string_literal: true

class UnsubscribeMailchimpService
  def process(email)
    list_id = ENV['MAILCHIMP_LIST_ID']

    subscriber_hash = Digest::MD5.hexdigest email.downcase

    $mailchimp.lists.update_list_member(list_id,
                                        subscriber_hash,
                                        status: 'unsubscribed')
  rescue StandardError => e
    Raven.capture_exception(e)
    false
  end
end
