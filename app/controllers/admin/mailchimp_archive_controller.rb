# frozen_string_literal: true

module Admin
  class MailchimpArchiveController < BaseController
    def new
      BulkArchiveMailchimpService.new.process

      redirect_to admin_mailchimp_sync_index_path, notice: 'Archiving all contacts in mailchimp please wait a couple of minutes.'
    end
  end
end
