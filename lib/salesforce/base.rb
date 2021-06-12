require 'restforce'

module Salesforce
  class Base

    include Salesforce::Util

    def initialize
      @client = Restforce.new :username       => ENV['SF_USERNAME'],
                              :password       => ENV['SF_PASSWORD'],
                              :security_token => ENV['SF_SECURITY_TOKEN'],
                              :client_id      => ENV['SF_CLIENT_ID'],
                              :client_secret  => ENV['SF_CLIENT_SECRET'],
                              :api_version    => 51.0
      @client.authenticate!
    end

    def create(sf_object, fields_map, entity_hash)
      @client.create!(sf_object, parse_fields_map(fields_map, entity_hash))
    end

    def update(sf_object, fields_map, entity_hash)
      @client.update(sf_object, parse_fields_map(fields_map, entity_hash))
    end

    def upsert(sf_object, sf_uniq_identifier="Id", fields_map, entity_hash)
      @client.upsert(sf_object, sf_uniq_identifier, parse_fields_map(fields_map, entity_hash))
    end

    def find(sf_object, sf_id)
      @client.find(sf_object, sf_id)
    end

    def query_all(sf_object)
      @client.query(sf_object)
    end

  end
end