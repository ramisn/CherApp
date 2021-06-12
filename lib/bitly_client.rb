# frozen_string_literal: true

class BitlyClient
  def self.short_url(long_url)
    client = Bitly::API::Client.new(token: ENV['BITLY_AUTH_TOKEN'])
    bitlink = client.shorten(long_url: long_url)
    bitlink.link
  end
end
