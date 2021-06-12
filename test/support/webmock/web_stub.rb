# frozen_string_literal: true

require 'webmock/minitest'

class WebStub
  EXPANDED_PROFILE = { 'summary' => { 'propSubType' => 'Residential' },
                       'building' => {
                         'interior' => { 'bsmtSize' => 715, 'floors' => 2 },
                         'parking' => { 'prkgSize' => 100 }
                       },
                       'assessment' => {
                         'assessed' => { 'assdImprValue' => 216_461.0, 'assdLandValue' => 337_087.0, 'assdTtlValue' => 553_548.0 },
                         'market' => { 'mktImprValue' => 216_461.0, 'mktLandValue' => 337_087.0, 'mktTtlValue' => 553_548.0 },
                         'tax' => {
                           'taxAmt' => 6_895.0,
                           'taxYear' => 2_019.0,
                           'exemption' => { 'ExemptionAmount1' => 7_000.0 },
                           'exemptiontype' =>
                              { 'Additional' => 'Y',
                                'Homeowner' => 'Y',
                                'Disabled' => 'N',
                                'Senior' => 'N',
                                'Veteran' => 'N',
                                'Widow' => 'N' }
                         },
                         'owner' => { 'owner1' => { 'lastName' => 'CISNEROS ', 'firstNameAndMi' => 'SHANNON C' } },
                         'mortgage' => { 'FirstConcurrent' => { 'amount' => 133_107, 'lenderLastName' => 'WELLS FARGO BANK' } }
                       } }.freeze

  PREFORECLOSURE_DETAILS = { 'Default' =>
                              [{  'borrowerNameOwner' => nil,
                                  'defaultAmount' => nil,
                                  'foreclosureRecordingDate' => nil,
                                  'judgmentAmount' => nil,
                                  'lenderNameFullStandardized' => nil,
                                  'loanBalance' => nil,
                                  'randomData' => 'For pass the first filter' },
                               { 'borrowerNameOwner' => 'MUSTAPHA NJIE',
                                 'defaultAmount' => 0,
                                 'foreclosureRecordingDate' => '2018-02-21T00:00:00',
                                 'judgmentAmount' => 20_574,
                                 'lenderNameFullStandardized' => 'Wells Fargo Bank',
                                 'loanBalance' => 3 }],
                             'Auction' =>
                                [{  'auctionAddress' => 'Marina Pirinola South',
                                    'auctionCity' => nil,
                                    'auctionDate' => '1900-01-01T00:00:00',
                                    'auctionTime' => '10:30AM' },
                                 {
                                   'auctionAddress' => 'Saint Maria Mazoru',
                                   'auctionCity' => 'Michitlan',
                                   'auctionDate' => '1992-03-03T00:00:00',
                                   'auctionTime' => '07:00AM'
                                 }] }.freeze

  def self.stup_ghost_blog_post
    posts = [{ title: 'Who to Co-Own Homes With?',
               url: 'https://cherappio-blog.herokuapp.com/who-to-co-own-homes-with/',
               feature_image: 'https://i.pravatar.cc/150?u=31',
               updated_at: '2019-11-26T02:44:17.000+00:00' }]
    GhostBlog.stubs(:last_3_posts).returns(JSON.parse(posts.to_json))
  end

  def self.stup_ghost_blog_post_with_error
    WebMock.stub_request(:any, /blog.cher.app.*/)
           .to_return(status: 500)
  end

  def self.stub_properties_request
    WebMock.stub_request(:any, /api.simplyrets.com.*/)
           .to_return(status: 200, body: [{ 'property': { 'bathsFull': 3,
                                                          'type': 'RES' },
                                            'mlsId': 94_106_826,
                                            'listingId': '94106826',
                                            'listPrice': 1_298_000,
                                            'listDate': Time.now,
                                            'minbeds': '1',
                                            'minbaths': '1',
                                            'photos': ['http://media.crmls.org/medias/d792afab-667a-4d1e-8b2c-3768489dfd2a.jpg'],
                                            'geo': { 'lat': 34.024212, 'lng': -118.496475 },
                                            'address': { 'streetName': 'Entrecolinas Place',
                                                         'full': '1633 Entrecolinas Place',
                                                         'city': 'Santa Monica' } }].to_json)
  end

  def self.stub_empty_properties_response
    WebMock.stub_request(:any, /api.simplyrets.com.*/)
           .to_return(status: 200, body: [].to_json)
  end

  def self.stub_redis_null
    Redis.any_instance.stubs(:get).returns(nil)
    Redis.any_instance.stubs(:set).returns(true)
  end

  def self.stub_redis_properties
    Redis.any_instance.stubs(:get).returns({ properties: [{ 'property': { 'bathsFull': 3,
                                                                          'type': 'RES' },
                                                            'mlsId': 94_106_826,
                                                            'listPrice': 1_298_000,
                                                            'listingId': 94_106_826,
                                                            'listDate': Time.now,
                                                            'photos': ['http://media.crmls.org/medias/d792afab-667a-4d1e-8b2c-3768489dfd2a.jpg'],
                                                            'geo': { 'lat': 34.024212, 'lng': -118.496475 },
                                                            'address': { 'streetName': 'Entrecolinas Place',
                                                                         'full': '1633 Entrecolinas Place',
                                                                         'city': 'Santa Monica' } }],
                                             next_batch_link: '' }.to_json)
    Redis.any_instance.stubs(:set).returns(true)
  end

  def self.stub_redis_property
    Redis.any_instance.stubs(:get).returns({ 'property': { 'bathsFull': 3,
                                                           'type': 'RES' },
                                             'mlsId': 94_106_826,
                                             'listPrice': 1_298_000,
                                             'listingId': 94_106_826,
                                             'listDate': Time.now,
                                             'startTime': Time.now,
                                             'endTime': Time.now,
                                             'minbeds': '1',
                                             'minbaths': '1',
                                             'photos': ['http://media.crmls.org/medias/d792afab-667a-4d1e-8b2c-3768489dfd2a.jpg'],
                                             'geo': { 'lat': '34.024212', 'lng': '-118.496475' },
                                             'address': { 'streetName': 'Entrecolinas Place',
                                                          'full': '1633 Entrecolinas Place' } }.to_json)
    Redis.any_instance.stubs(:set).returns(true)
  end

  def self.stub_property_places
    Places.stubs(:number_of_places_by_type).returns(3)
  end

  def self.stub_sendgrid_validator
    WebMock.stub_request(:any, %r{api.sendgrid.com/v3/validations/email.*})
           .to_return(status: 200, body: { result: { verdict: 'Valid' } }.to_json)
  end

  def self.stub_sendgrid_contacts
    WebMock.stub_request(:any, %r{api.sendgrid.com/v3/marketing/contacts.*})
           .to_return(status: 200, body: '')
  end

  def self.stub_sendgrid_contacts_search
    WebMock.stub_request(:any, %r{api.sendgrid.com/v3/marketing/contacts.*})
           .to_return(status: 200, body: { contact_count: 0 }.to_json)
  end

  def self.stub_sendgrid_single_send
    WebMock.stub_request(:any, %r{api.sendgrid.com/v3/mail/send.*})
           .to_return(status: 200, body: '')
  end

  def self.stub_twilio_sms
    WebMock.stub_request(:any, %r{api.twilio.com/2010-04-01/Accounts.*})
           .to_return(status: 200, body: '')
  end

  def self.stub_bitly
    WebMock.stub_request(:any, /api-ssl.bitly.com.*/)
           .to_return(status: 200, body: { link: 'https://bit.ly/1sNZMwL' }.to_json)
  end

  def self.stub_walkscore
    WebMock.stub_request(:any, %r{api.walkscore.com/score.*})
           .to_return(status: 200, body: { 'walkscore': '99',
                                           'description': "Walker's Paradise",
                                           'transit': { 'score': '100', 'description': "Rider's Paradise" },
                                           'bike': { 'score': '100', 'description': 'Very Bikeable' } }.to_json)
  end

  def self.stub_attom
    WebMock.stub_request(:any, %r{api.gateway.attomdata.com/.*})
           .to_return(status: 200, body: { property: [] }.to_json)
  end

  def self.stub_frankenstein
    extra_data = { walkscore: nil, schools: nil, hospitals: nil, restaurants: nil, history: nil, sales_trend: nil,
                   expanded_profile: EXPANDED_PROFILE, preforeclosure_details: PREFORECLOSURE_DETAILS }
    PropertyFrankensteinGetterService.any_instance
                                     .stubs(:execute)
                                     .returns(extra_data)
  end

  def self.stub_mailchimp
    WebMock.stub_request(:any, %r{us20.api.mailchimp.com/.*})
           .to_return(status: 200, body: { property: [] }.to_json)
  end

  def self.stub_stripe_customer_list
    WebMock.stub_request(:get, %r{https://api.stripe.com/v1/customers.*})
           .to_return(status: 200, body: { data: [] }.to_json)
  end

  def self.stub_stripe_customer_creation
    WebMock.stub_request(:post, %r{https://api.stripe.com/v1/customers.*})
           .to_return(status: 200, body: { 'id': '123abc', 'invoice_settings': { 'default_payment_method': '' }, 'subscriptions': { 'data': [{ id: '123abc' }] } }.to_json)
  end

  def self.stub_stripe_subscription_creation
    WebMock.stub_request(:post, %r{https://api.stripe.com/v1/subscriptions.*})
           .to_return(status: 200, body: { 'id': '123abc', 'latest_invoice': '123abc' }.to_json)
  end

  def self.stub_stripe_invoice
    WebMock.stub_request(:get, %r{https://api.stripe.com/v1/invoices.*})
           .to_return(status: 200, body: { 'id': '123abc', 'payment_intent': '123abc' }.to_json)
  end

  def self.stub_stripe_payment_intent
    WebMock.stub_request(:get, %r{https://api.stripe.com/v1/payment_intents.*})
           .to_return(status: 200, body: { 'id': '123abc', 'status': 'succeeded', 'amount': 19_900 }.to_json)
  end

  def self.stub_stripe_customer_payment_methods
    WebMock.stub_request(:get, 'https://api.stripe.com/v1/payment_methods/')
           .to_return(status: 200, body: { card: { 'id': '123abc', last4: '4242' } }.to_json)
  end

  def self.stub_stripe_customer
    WebMock.stub_request(:get, %r{https://api.stripe.com/v1/customers.*})
           .to_return(status: 200, body: { data: [{ 'id': '123abc' }] }.to_json)
  end

  def self.stub_stripe_no_customer
    WebMock.stub_request(:get, %r{https://api.stripe.com/v1/customers.*})
           .to_return(status: 200, body: { data: [] }.to_json)
  end

  def self.stub_stripe_charge
    WebMock.stub_request(:post, %r{https://api.stripe.com/v1/charges.*})
           .to_return(status: 200, body: { 'id': '123abc', 'amount': 9900 }.to_json)
  end

  def self.stub_stripe_customer_last_4
    WebMock.stub_request(:get, %r{https://api.stripe.com/v1/payment_methods*})
           .to_return(status: 200, body: { data: [{ card: { last4: '4242' } }] }.to_json)
  end

  def self.stub_stripe_payment_method_creation
    WebMock.stub_request(:post, 'https://api.stripe.com/v1/payment_methods')
           .to_return(status: 200, body: { id: '123abc' }.to_json)
  end

  def self.stub_stripe_customer_payment_attach
    WebMock.stub_request(:post, %r{https://api.stripe.com/v1/payment_methods/.*/attach})
           .to_return(status: 200, body: {}.to_json)
  end

  def self.stub_stripe_customer_update
    WebMock.stub_request(:post, %r{https://api.stripe.com/v1/customers/.*})
           .to_return(status: 200, body: {}.to_json)
  end

  def self.stub_stripe_subscription_removal
    WebMock.stub_request(:delete, %r{https://api.stripe.com/v1/subscriptions/.*})
           .to_return(status: 200, body: {}.to_json)
  end

  def self.stub_twilio_chat_response
    WebMock.stub_request(:get, %r{https://chat.twilio.com/v2/Services.*})
           .to_return(status: 200, body: '')
  end

  def self.stub_twilio_chat_not_found_response
    WebMock.stub_request(:get, %r{https://chat.twilio.com/v2/Services.*})
           .to_return(status: 404, body: '')
  end

  def self.stub_twilio_chat_member_wiht_role
    WebMock.stub_request(:get, %r{https://chat.twilio.com/v2/Services.*})
           .to_return(status: 200, body: { role_sid: '123abc' }.to_json)
  end
end
