class SalesforceJob < ApplicationJob	
  sidekiq_options queue: :default, retry: false
  
  def perform
    puts "SalesforceJob is performed"
    
    sf_obj = Salesforce::Lead.new
    puts sf_obj.inspect

    search_critera = "(LastModifiedDate >= YESTERDAY AND LastModifiedDate <= TODAY) AND (Status = 'New')"
    search_open = "(Status = 'New')"
    
    # sf_leads = sf_obj.query_all("SELECT Id, Name, Email, Company, Phone, Status, LastModifiedDate FROM Lead where #{search_open} LIMIT 1")
    sf_leads = sf_obj.query_all("SELECT FIELDS(ALL) FROM Lead where #{search_critera} LIMIT 5")
        puts "---leads---"
        puts sf_leads.count

        sf_leads.each do |l|
          # puts l.Id, l.Name, l.Email, l.Company, l.Phone, l.LastModifiedDate
          puts l.inspect
          # SalesForceContact.find_or_create_by(sf_id: l.Id, email:l.Email, name:l.Name, phone_number:l.Phone, provider:l.Company)
        end

    # if user.lead.present?
    # 	# update data in Salesforce only if Lead is still Open
    #   # do not update data once lead gets converted/ cancelled
    #   if user.lead.is_open?
    #     sf_obj.update(Salesforce::Lead::SF_OBJ_NAME, sf_obj.fields_map, entity_hash)
    #   end
    # else
    #   user.build_lead(status: Lead.statuses["1"]).save!
    #   puts user.inspect
    #   # Push data to Salesforce
    #   user.company_name = "Lead From Cher"
    #   sf_lead_id = sf_obj.upsert("Lead", "Id", sf_obj.fields_map, user.attributes)
    #   puts sf_lead_id
    #   # Update DB entry with Salesforce Lead ID
    #   Lead.where(user_id: user.id).update_all(salesforce_id: sf_lead_id)
    # end
  end
end