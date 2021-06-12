# frozen_string_literal: true

module Admin
  class MailchimpSyncController < BaseController
    def index
      @conditions = (Prospect::LETTER_MAPPING.keys + User::LETTER_MAPPING.keys).map { |k| 'A' + k.to_s }
    end

    def create
      BulkArchiveMailchimpService.new.process
      BulkAddMailchimpService.new(params[:conditions]).process

      redirect_to admin_mailchimp_sync_index_path, notice: 'Contacts are syncing with MailChimp please wait a couple of minutes'
    end
  end
end
