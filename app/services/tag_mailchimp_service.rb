# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

class TagMailchimpService
  LIST_ID = ENV['MAILCHIMP_LIST_ID']

  def process(email, type, status = 'active')
    subscriber_hash = Digest::MD5.hexdigest email.downcase
    # TODO: This method in the gem doesn't work, need to fix it.
    # response = $mailchimp.lists.update_list_member_tags list_id, subscriber_hash, { tags: [
    #                                                                                   {
    #                                                                                     name: "newtag",
    #                                                                                     status: "active"
    #                                                                                   }
    #                                                                                 ]
    #

    uri = URI.parse("https://us20.api.mailchimp.com/3.0/lists/#{LIST_ID}/members/#{subscriber_hash}/tags")
    request = build_request(uri, type, status)
    req_options = {
      use_ssl: uri.scheme == 'https'
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    response
  rescue StandardError => e
    Raven.capture_exception(e)
    false
  end

  private

  def build_request(uri, type, status)
    request = Net::HTTP::Post.new(uri)
    request.basic_auth('aa', ENV['MAILCHIMP_API_KEY'])
    request.body = JSON.dump(
      'tags' => [
        {
          'name' => type,
          'status' => status
        }
      ]
    )
    request
  end
end
