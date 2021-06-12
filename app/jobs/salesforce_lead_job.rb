class SalesforceLeadJob < ApplicationJob	
  sidekiq_options queue: :default, retry: false
  
  def perform(user_email)
    puts "SalesforceJob is performed"
    puts user_email
    user = User.select("id, first_name, last_name, email, phone_number, company_name").where(email: user_email).first
    sf_obj = Salesforce::Lead.new
    puts sf_obj.inspect

    if user.lead.present?
    	# update data in Salesforce only if Lead is still Open
      # do not update data once lead gets converted/ cancelled
      if user.lead.is_open?
        sf_obj.update(Salesforce::Lead::SF_OBJ_NAME, sf_obj.fields_map, entity_hash)
      end
    else
      user.build_lead(status: Lead.statuses["1"]).save!
      puts user.inspect
      # Push data to Salesforce
      user.company_name = "Lead From Cher"
      sf_lead_id = sf_obj.upsert("Lead", "Id", sf_obj.fields_map, user.attributes)
      puts sf_lead_id
      # Update DB entry with Salesforce Lead ID
      Lead.where(user_id: user.id).update_all(salesforce_id: sf_lead_id)
    end
  end
end
