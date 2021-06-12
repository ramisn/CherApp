# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_10_011248) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.string "trackable_type"
    t.bigint "trackable_id"
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "key"
    t.jsonb "parameters"
    t.string "recipient_type"
    t.bigint "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["owner_type", "owner_id"], name: "index_activities_on_owner_type_and_owner_id"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["recipient_type", "recipient_id"], name: "index_activities_on_recipient_type_and_recipient_id"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id"
  end

  create_table "areas", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "chime_meetings", force: :cascade do |t|
    t.string "meeting_id", null: false
    t.string "external_meeting_id", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.bigint "owner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "publication_id"
    t.string "post_type"
    t.bigint "post_id"
    t.index ["owner_id"], name: "index_comments_on_owner_id"
    t.index ["post_type", "post_id"], name: "index_comments_on_post_type_and_post_id"
    t.index ["publication_id"], name: "index_comments_on_publication_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.integer "status", default: 0
    t.integer "contactable_id"
    t.string "contactable_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "discarded_at"
  end

  create_table "flagged_properties", force: :cascade do |t|
    t.string "property_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "city", default: "", null: false
    t.bigint "price_on_flag", default: 0, null: false
    t.string "status_on_flag"
    t.index ["property_id"], name: "index_flagged_properties_on_property_id"
    t.index ["user_id"], name: "index_flagged_properties_on_user_id"
  end

  create_table "friend_requests", force: :cascade do |t|
    t.bigint "requester_id", null: false
    t.bigint "requestee_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["requestee_id"], name: "index_friend_requests_on_requestee_id"
    t.index ["requester_id"], name: "index_friend_requests_on_requester_id"
  end

  create_table "houses", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.string "address"
    t.string "state"
    t.string "county"
    t.integer "price"
    t.integer "home_type"
    t.integer "beds"
    t.integer "full_baths"
    t.integer "half_baths"
    t.decimal "interior_area"
    t.decimal "lot_size"
    t.integer "year_build"
    t.decimal "hoa_dues"
    t.decimal "basement_area"
    t.decimal "garage_area"
    t.text "description"
    t.text "details"
    t.date "date_for_open_house"
    t.time "start_hour_for_open_house"
    t.time "end_hour_for_open_house"
    t.string "website"
    t.string "phone_contact"
    t.string "email_contact"
    t.integer "status", default: 0, null: false
    t.boolean "accept_terms"
    t.decimal "ownership_percentage"
    t.boolean "receive_analysis", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "selling_percentage", default: 0, null: false
    t.integer "down_payment", default: 0, null: false
    t.integer "monthly_mortgage", default: 0, null: false
    t.string "mlsid"
    t.boolean "draft", default: false
    t.index ["owner_id"], name: "index_houses_on_owner_id"
  end

  create_table "houses_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "house_id"
    t.index ["house_id"], name: "index_houses_users_on_house_id"
    t.index ["user_id"], name: "index_houses_users_on_user_id"
  end

  create_table "leads", force: :cascade do |t|
    t.string "salesforce_id"
    t.integer "status"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "post_type"
    t.bigint "post_id"
    t.index ["post_type", "post_id"], name: "index_likes_on_post_type_and_post_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "live_factors", force: :cascade do |t|
    t.string "question", null: false
    t.integer "weight", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "start_label"
    t.string "end_label"
  end

  create_table "loan_participants", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "loan_id"
    t.boolean "accepted_request", default: false, null: false
    t.string "token"
    t.index ["loan_id"], name: "index_loan_participants_on_loan_id"
    t.index ["user_id"], name: "index_loan_participants_on_user_id"
  end

  create_table "loans", force: :cascade do |t|
    t.bigint "user_id"
    t.string "property_id"
    t.string "property_street"
    t.string "property_city"
    t.string "property_state"
    t.string "property_zipcode"
    t.string "property_county"
    t.string "property_type"
    t.boolean "property_occupied"
    t.boolean "first_home", null: false
    t.boolean "live_there", null: false
    t.integer "status", default: 0, null: false
    t.string "unique_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_loans_on_user_id"
  end

  create_table "message_channels", force: :cascade do |t|
    t.string "sid"
    t.string "participants", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0
    t.string "purpose", default: "conversation"
    t.string "image_url"
  end

  create_table "notification_settings", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.json "preferences", default: {}
    t.index ["user_id"], name: "index_notification_settings_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "owner_id"
    t.bigint "recipient_id", null: false
    t.string "key", null: false
    t.integer "status", default: 0, null: false
    t.json "params"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["owner_id"], name: "index_notifications_on_owner_id"
    t.index ["recipient_id"], name: "index_notifications_on_recipient_id"
  end

  create_table "payments", force: :cascade do |t|
    t.string "transaction_id", null: false
    t.bigint "user_id", null: false
    t.string "receipt_url", null: false
    t.integer "amount", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "clique_plan"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "posts", force: :cascade do |t|
    t.uuid "uuid", null: false
    t.string "title"
    t.string "feature_image"
    t.string "plaintext"
    t.string "slug"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "professional_reviews", force: :cascade do |t|
    t.bigint "reviewer_id", null: false
    t.bigint "reviewed_id", null: false
    t.text "comment"
    t.integer "local_knowledge", default: 0, null: false
    t.integer "process_expertise", default: 0, null: false
    t.integer "responsiveness", default: 0, null: false
    t.integer "negotiation_skills", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
    t.index ["reviewed_id"], name: "index_professional_reviews_on_reviewed_id"
    t.index ["reviewer_id"], name: "index_professional_reviews_on_reviewer_id"
  end

  create_table "promo_codes", force: :cascade do |t|
    t.string "name", null: false
    t.string "class_name", null: false
    t.date "expiration"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "promo_codes_users", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "promo_code_id"
    t.index ["promo_code_id"], name: "index_promo_codes_users_on_promo_code_id"
    t.index ["user_id"], name: "index_promo_codes_users_on_user_id"
  end

  create_table "property_prices", force: :cascade do |t|
    t.string "property_id", null: false
    t.integer "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "property_searches", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "search_in", null: false
    t.string "search_type"
    t.string "minprice"
    t.string "maxprice"
    t.string "minbeds"
    t.string "minbaths"
    t.string "types", default: [], array: true
    t.string "statuses", default: [], array: true
    t.string "minarea"
    t.string "maxarea"
    t.string "minyear"
    t.string "maxyear"
    t.string "minacres"
    t.string "maxacres"
    t.boolean "water", default: false, null: false
    t.string "maxdom"
    t.string "features"
    t.string "exteriorFeatures"
    t.string "alias", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "points", default: "[]"
    t.index ["user_id"], name: "index_property_searches_on_user_id"
  end

  create_table "prospects", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_subscribed", default: true, null: false
    t.boolean "marked_as_spam", default: false, null: false
    t.boolean "bounced", default: false, null: false
    t.integer "role", default: 0
    t.string "first_name"
    t.string "city"
    t.datetime "mailchimp_updated_at"
    t.integer "mailchimp_sync_status", default: 0
    t.string "phone_number"
    t.string "last_name"
    t.datetime "discarded_at"
    t.index ["email"], name: "index_prospects_on_email", unique: true
  end

  create_table "publications", force: :cascade do |t|
    t.bigint "owner_id"
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "recipient_id"
    t.index ["owner_id"], name: "index_publications_on_owner_id"
    t.index ["recipient_id"], name: "index_publications_on_recipient_id"
  end

  create_table "rentals", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.string "address", null: false
    t.string "state", null: false
    t.integer "monthly_rent", null: false
    t.integer "security_deposit"
    t.integer "bedrooms", null: false
    t.integer "bathrooms", null: false
    t.integer "square_feet"
    t.date "date_available"
    t.integer "lease_duration", null: false
    t.boolean "hide_address", default: false
    t.boolean "ac"
    t.boolean "balcony_or_deck"
    t.boolean "furnished"
    t.boolean "hardwood_floor"
    t.boolean "wheelchair_access"
    t.boolean "garage_parking"
    t.boolean "off_street_parking"
    t.string "additional_amenities"
    t.integer "laundry"
    t.boolean "permit_pets"
    t.boolean "permit_cats"
    t.boolean "permit_small_dogs"
    t.boolean "permit_large_dogs"
    t.text "about"
    t.text "lease_summary"
    t.string "name"
    t.string "phone_number", null: false
    t.string "email"
    t.integer "listed_by_type", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id"], name: "index_rentals_on_owner_id"
  end

  create_table "responses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "live_factor_id", null: false
    t.integer "response", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["live_factor_id"], name: "index_responses_on_live_factor_id"
    t.index ["user_id"], name: "index_responses_on_user_id"
  end

  create_table "sales_force_contacts", force: :cascade do |t|
    t.string "sf_id"
    t.string "string"
    t.string "email"
    t.string "name"
    t.string "phone_number"
    t.string "provider"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "seen_properties", force: :cascade do |t|
    t.bigint "user_id"
    t.string "property_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "city", default: "", null: false
    t.index ["user_id"], name: "index_seen_properties_on_user_id"
  end

  create_table "shapes", force: :cascade do |t|
    t.string "name", null: false
    t.integer "shape_type", default: 0, null: false
    t.float "radius", default: 0.0
    t.jsonb "center", default: "[]"
    t.jsonb "coordinates", default: "[]"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_shapes_on_user_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "provider"
    t.string "uid"
    t.string "first_name"
    t.text "image"
    t.integer "role"
    t.integer "score"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "verification_type"
    t.datetime "discarded_at"
    t.string "last_question_reponded"
    t.string "last_name"
    t.integer "test_attempts", default: 0, null: false
    t.date "test_blocked_till"
    t.date "test_reset_period", default: -> { "CURRENT_TIMESTAMP" }
    t.string "search_history", default: [], array: true
    t.string "search_intent"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.boolean "needs_verification", default: false, null: false
    t.boolean "accept_terms_and_conditions", default: true, null: false
    t.boolean "accept_privacy_policy", default: true, null: false
    t.boolean "accept_referral_agreement", default: false
    t.boolean "sell_my_info", default: true, null: false
    t.string "description"
    t.string "company_name"
    t.string "address1"
    t.string "areas", default: [], array: true
    t.integer "status", default: 0, null: false
    t.string "address2"
    t.string "number_license"
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.integer "professional_role"
    t.string "specialties", default: [], array: true
    t.boolean "proffesional_verfied", default: false
    t.integer "funding"
    t.integer "co_borrowers"
    t.date "end_of_clique"
    t.string "plan_type"
    t.boolean "contact_professional", default: false, null: false
    t.string "referral_code"
    t.string "discard_token"
    t.string "phone_number"
    t.datetime "mailchimp_updated_at"
    t.integer "mailchimp_sync_status", default: 0
    t.boolean "skip_onbording", default: false, null: false
    t.integer "background_check_status", default: 0
    t.string "middle_name"
    t.date "date_of_birth"
    t.string "slug", default: "", null: false
    t.string "ssn"
    t.integer "message_credits", default: 0, null: false
    t.integer "feedback_plan_step", default: 0
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.boolean "track_share_a_sale"
    t.datetime "last_seen_at"
    t.integer "gender"
    t.integer "property_type"
    t.integer "budget_from"
    t.integer "budget_to"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "publications"
  add_foreign_key "comments", "users", column: "owner_id"
  add_foreign_key "friend_requests", "users", column: "requestee_id"
  add_foreign_key "friend_requests", "users", column: "requester_id"
  add_foreign_key "houses", "users", column: "owner_id"
  add_foreign_key "houses_users", "houses"
  add_foreign_key "houses_users", "users"
  add_foreign_key "likes", "users"
  add_foreign_key "loan_participants", "loans"
  add_foreign_key "loan_participants", "users"
  add_foreign_key "loans", "users"
  add_foreign_key "notification_settings", "users"
  add_foreign_key "notifications", "users", column: "owner_id"
  add_foreign_key "notifications", "users", column: "recipient_id"
  add_foreign_key "payments", "users"
  add_foreign_key "professional_reviews", "users", column: "reviewed_id"
  add_foreign_key "professional_reviews", "users", column: "reviewer_id"
  add_foreign_key "promo_codes_users", "promo_codes"
  add_foreign_key "promo_codes_users", "users"
  add_foreign_key "property_searches", "users"
  add_foreign_key "publications", "users", column: "owner_id"
  add_foreign_key "publications", "users", column: "recipient_id"
  add_foreign_key "rentals", "users", column: "owner_id"
  add_foreign_key "responses", "users"
  add_foreign_key "seen_properties", "users"
  add_foreign_key "shapes", "users"
end
