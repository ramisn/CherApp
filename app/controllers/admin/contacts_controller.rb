# frozen_string_literal: true

require 'csv'

module Admin
  class ContactsController < BaseController
    def create
      respond_to do |format|
        format.csv do
          if uploaded_file_is_valid?
            CSV.foreach(@contacts_file, headers: true) do |contact|
              ContactJob.perform_later(email: contact['email'],
                                       role: contact['role'],
                                       first_name: contact['first_name'],
                                       city: contact['city'])
            end
          end
          flash[:notice] = t('flashes.contacts.create_csv.notice')
          redirect_to admin_contacts_path
        end
      end
    end

    def index
      @contacts = contacts

      respond_to do |format|
        format.html {}
        format.csv do
          headers['Content-Disposition'] = 'attachment; filename=contacts.csv'
          headers['Content-Type'] ||= 'text/csv'
        end
      end
    end

    def sfindex
      sf_contacts = sf_contacts_by_filter_param
      sf_contacts.inspect
      @sf_contacts = sf_contacts
      # return sf_contacts.page(params[:page]).per(150)

      respond_to do |format|
        format.html {}
        format.csv do
          headers['Content-Disposition'] = 'attachment; filename=Salesforce_contacts.csv'
          headers['Content-Type'] ||= 'text/csv'
        end
      end
    end

    def destroy
      DestroyContactService.new(params[:id]).execute

      flash[:notice] = I18n.t('admin.contacts.deleted_successfully')
      redirect_to admin_contacts_path
    end

    private

    def contacts
      params[:filter] = 'created' if filter.nil?
      contacts = contacts_by_filter_param

      return contacts.page(params[:page]).per(150) if subfilter.nil?

      subfiltered_contacts = contacts.select { |c| c.role.to_s == subfilter }
      paginate_array(subfiltered_contacts)
    end

    def contacts_by_filter_param
      contacts = params[:search].blank? ? Contact.kept : Contact.by_search(params[:search])

      case params[:filter]
      when 'created'
        contacts.where(status: 'created').includes(:contactable)
      when 'all'
        contacts.includes(:contactable)
      when 'others'
        contacts.where('status != 0').includes(:contactable)
      when nil
        contacts
      end
    end

    def sf_contacts_by_filter_param
      # sf_contacts = params[:search].blank? ? Contact.kept : Contact.by_search(params[:search])
      # sf_contacts = SalesForceContact.where.not(email: nil)
      # sf_contacts = SalesForceContact
      params[:filter] = 'with_email' if filter.nil?
      case params[:filter]
      when 'from_kixie'
        SalesForceContact.where(provider: 'Lead From Kixie')
      when 'with_email'
        SalesForceContact.where.not(email: nil)
      when 'others'
        SalesForceContact.where("provider != 'Lead From Kixie'")
      # when nil
      #   contacts
      end
    end

    def filter
      params[:filter]
    end

    def paginate_array(contacts)
      Kaminari.paginate_array(contacts)
              .page(params[:page])
              .per(150)
    end

    def paginate_array(sf_contacts)
      Kaminari.paginate_array(sf_contacts)
              .page(params[:page])
              .per(150)
    end

    def subfilter
      params[:subfilter]
    end

    def uploaded_file_is_valid?
      @contacts_file = params[:contact][:file]
      return true if @contacts_file

      flash[:alert] = t('flashes.contacts.create_csv.alert')
      redirect_to admin_contacts_path
    end
  end
end
