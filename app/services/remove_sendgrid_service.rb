# frozen_string_literal: true

class RemoveSendgridService < BaseSendgridService
  def process(contact_id, list_id)
    RestClient::Request.execute(method: :delete, url: "https://api.sendgrid.com/v3/marketing/lists/#{list_id}/contacts?contact_ids=#{contact_id}",
                                headers: { 'Authorization': "Bearer #{ENV['SENDGRID_API_KEY']}" })
  end
end
