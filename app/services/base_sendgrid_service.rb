# frozen_string_literal: true

require 'rest-client'

class BaseSendgridService
  PROD_SENGRID_LISTS = { prospect_user: 'b5702f0a-b02e-44b9-9b19-c1c231f27d96',
                         prospect_customer_other: '47af5389-1fb5-432d-ae7e-8a59d1e76652',
                         prospect_general_contractor: '7112e838-bb61-429e-aebe-8180cf2717b4',
                         prospect_loan_officer: '01ef5535-3ecb-4e6a-beae-1dc767e67947',
                         prospect_mortgage_broker: 'f82d20c7-a4ac-4549-8866-6fcbf5710800',
                         prospect_realtor: '7d96d3f5-2786-445b-aa43-a7620a421ca2',
                         prospect_title_officer: '554ca3ba-872b-4dc7-b5a6-ef2f1bef71c2',
                         prospect_escrow_officer: '7b57950c-8236-44da-aa49-b5b15802dd43',
                         prospect_subscriber: '554ca3ba-872b-4dc7-b5a6-ef2f1bef71c2',
                         customer_other: '47af5389-1fb5-432d-ae7e-8a59d1e76652',
                         escrow_officer: '186895a5-7074-4183-89e2-52e5645b2813',
                         general_contractor: 'e1ec2143-333a-4b02-a20c-d26cbeaa7fa6',
                         loan_officer: '9a30e128-9206-4499-9b1d-33da19aec3ff',
                         mortgage_broker: '44aaefb6-7257-4a19-b68e-011d55083ebd',
                         realtor_clique: '4d54e915-84ac-43c7-8ff1-3866c130c5a0',
                         realtor: 'ef508d59-e017-4810-bc2e-8a314c505125',
                         title_officer: '60b2015f-8141-4122-a886-83af12caff09',
                         user: '56526d92-3f30-489c-a8e2-cbfa9ea2ed50',
                         unsubscribe: 'cce898ac-5119-4fda-8e0c-33897d99d99f',
                         prospect_prospect: 'b00caa30-33d5-4123-8783-ceba52147685' }.freeze

  DEV_SENGRID_LISTS = { prospect_user: 'dc010ede-6606-4b1a-b8eb-0db05530436d',
                        prospect_customer_other: '9604340a-7512-464e-82b1-1694c48b096c',
                        prospect_general_contractor: '1394a83f-89e4-4483-978b-b8792826599c',
                        prospect_loan_officer: '88d75f73-4cba-4329-ad4f-8084c58e3f5c',
                        prospect_mortgage_broker: '032da824-a3a7-479d-a97f-a30171394643',
                        prospect_realtor: 'a8b35a8c-a7e5-4ea0-a80f-0815586d1940',
                        prospect_title_officer: 'e3f42df4-5401-4f90-93c7-00bb2b02abff',
                        prospect_escrow_officer: 'bc1ace92-625c-4545-9192-0f34acb2f9d8',
                        prospect_subscriber: 'bc1ace92-625c-4545-9192-0f34acb2f9d8',
                        other: '3ef274f5-4963-4f87-a4a2-47dc321d5123',
                        escrow_officer: '2fdad475-00b8-459c-8fd1-732a406a6079',
                        general_contractor: 'cf20d282-f2ba-46f1-9896-6d56ad28b0e7',
                        loan_officer: '6d7d3937-ccc3-43ad-820f-9342b2823d32',
                        mortgage_broker: '03e46c51-ff7e-48fc-be2f-cd17c58adc40',
                        realtor_clique: 'ffd6c862-43cf-4531-a897-80ed63f082bc',
                        realtor: '7fae9bc1-2908-4cb6-981b-39c8301407d0',
                        title_officer: 'cdcf3cfc-c174-462b-9bf9-57ee1b7c26ce',
                        user: '6b3eb620-1c51-4563-825d-44fcd80d897d',
                        unsubscribe: '789be37b-6bec-4858-9f10-00b16541fddc' }.freeze

  def list
    return PROD_SENGRID_LISTS if Rails.env.production?

    DEV_SENGRID_LISTS
  end
end
