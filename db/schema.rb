# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180110183642) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_modules", force: :cascade do |t|
    t.integer  "business_id"
    t.integer  "kind"
    t.boolean  "active"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.json     "settings"
  end

  create_table "affiliate_payments", force: :cascade do |t|
    t.text     "title"
    t.integer  "subscription_affiliate_id"
    t.integer  "subscription_payment_id"
    t.text     "description"
    t.decimal  "amount",                    precision: 6, scale: 2, default: 0.0
    t.boolean  "paid",                                              default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ahoy_messages", force: :cascade do |t|
    t.string   "token"
    t.text     "to"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "mailer"
    t.text     "subject"
    t.datetime "sent_at"
    t.datetime "opened_at"
    t.datetime "clicked_at"
    t.integer  "business_id"
  end

  add_index "ahoy_messages", ["token"], name: "index_ahoy_messages_on_token", using: :btree
  add_index "ahoy_messages", ["user_id", "user_type"], name: "index_ahoy_messages_on_user_id_and_user_type", using: :btree

  create_table "authorizations", force: :cascade do |t|
    t.integer  "business_id",                                  null: false
    t.integer  "user_id",                                      null: false
    t.integer  "role",                                         null: false
    t.json     "settings"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.boolean  "contact_message_notifications", default: true, null: false
    t.boolean  "review_notifications",          default: true, null: false
    t.string   "invite_message"
  end

  add_index "authorizations", ["business_id"], name: "index_authorizations_on_business_id", using: :btree
  add_index "authorizations", ["user_id"], name: "index_authorizations_on_user_id", using: :btree

  create_table "before_afters", force: :cascade do |t|
    t.integer  "business_id",      null: false
    t.text     "title",            null: false
    t.text     "description"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "meta_description"
    t.text     "facebook_id"
    t.text     "slug"
    t.time     "published_time"
    t.boolean  "published_status"
    t.datetime "published_on"
  end

  add_index "before_afters", ["business_id"], name: "index_before_afters_on_business_id", using: :btree
  add_index "before_afters", ["id", "slug"], name: "index_before_afters_on_id_and_slug", unique: true, using: :btree

  create_table "blocks", force: :cascade do |t|
    t.integer  "frame_id",                              null: false
    t.string   "frame_type",                            null: false
    t.integer  "link_id"
    t.string   "link_type"
    t.string   "type",                                  null: false
    t.string   "theme"
    t.string   "style"
    t.string   "link_label"
    t.text     "heading"
    t.text     "subheading"
    t.text     "text"
    t.text     "link_external_url"
    t.boolean  "link_target_blank", default: false,     null: false
    t.boolean  "link_no_follow",    default: false,     null: false
    t.integer  "link_version",      default: 0,         null: false
    t.string   "spoof"
    t.json     "settings"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "layout",            default: "default"
    t.integer  "position",          default: 0,         null: false
    t.boolean  "show_our_content",  default: true
  end

  add_index "blocks", ["frame_type", "frame_id"], name: "index_blocks_on_frame_type_and_frame_id", using: :btree
  add_index "blocks", ["link_type", "link_id"], name: "index_blocks_on_link_type_and_link_id", using: :btree

  create_table "bounced_emails", force: :cascade do |t|
    t.text     "bounce_type"
    t.text     "email_address"
    t.text     "status"
    t.text     "action"
    t.text     "diagnostic_code"
    t.text     "reporting_mta"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "business_location_update_requests", force: :cascade do |t|
    t.integer  "business_update_request_id"
    t.string   "name",                                                                null: false
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "phone_number"
    t.string   "email"
    t.text     "service_area"
    t.boolean  "external_service_area",                               default: false, null: false
    t.decimal  "latitude",                   precision: 10, scale: 6
    t.decimal  "longitude",                  precision: 10, scale: 6
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
  end

  add_index "business_location_update_requests", ["business_update_request_id"], name: "business_location_business_update_idx", using: :btree

  create_table "business_update_requests", force: :cascade do |t|
    t.integer  "business_id"
    t.integer  "request_business_id"
    t.string   "name",                            null: false
    t.string   "tagline"
    t.string   "website_url"
    t.string   "facebook_id"
    t.string   "google_plus_id"
    t.string   "linkedin_id"
    t.string   "twitter_id"
    t.string   "youtube_id"
    t.text     "description"
    t.integer  "kind",                default: 0, null: false
    t.integer  "year_founded"
    t.string   "citysearch_id"
    t.string   "instagram_id"
    t.string   "pinterest_id"
    t.string   "yelp_id"
    t.integer  "plan",                default: 0, null: false
    t.integer  "cce_id"
    t.text     "cce_url"
    t.string   "foursquare_id"
    t.string   "zillow_id"
    t.string   "opentable_id"
    t.string   "trulia_id"
    t.string   "realtor_id"
    t.string   "tripadvisor_id"
    t.string   "houzz_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "businesses", force: :cascade do |t|
    t.string   "name",                                           null: false
    t.string   "tagline"
    t.string   "website_url"
    t.string   "facebook_id"
    t.string   "google_plus_id"
    t.string   "linkedin_id"
    t.string   "twitter_id"
    t.string   "youtube_id"
    t.text     "description"
    t.integer  "kind",                           default: 0,     null: false
    t.integer  "year_founded"
    t.json     "settings"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "citysearch_id"
    t.string   "instagram_id"
    t.string   "pinterest_id"
    t.string   "yelp_id"
    t.text     "values"
    t.text     "history"
    t.text     "vision"
    t.text     "community_involvement"
    t.integer  "plan",                           default: 0,     null: false
    t.integer  "cce_id"
    t.text     "cce_url"
    t.text     "facebook_token"
    t.text     "foursquare_id"
    t.text     "zillow_id"
    t.text     "opentable_id"
    t.text     "trulia_id"
    t.text     "realtor_id"
    t.text     "tripadvisor_id"
    t.text     "houzz_id"
    t.boolean  "to_dos_enabled"
    t.boolean  "bill_online",                    default: true
    t.boolean  "subscription_billing_roadblock", default: false
    t.boolean  "in_impact",                      default: true
    t.boolean  "affiliate_activated",            default: false
    t.boolean  "membership_org",                 default: false
    t.text     "slug"
  end

  create_table "calendar_widgets", force: :cascade do |t|
    t.string   "name"
    t.string   "public_label"
    t.string   "uuid"
    t.integer  "business_id"
    t.integer  "max_items"
    t.boolean  "enable_search"
    t.text     "company_list_ids", default: [],              array: true
    t.boolean  "show_our_content"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "default_view"
    t.integer  "filter_kinds",     default: [],              array: true
  end

  add_index "calendar_widgets", ["business_id"], name: "index_calendar_widgets_on_business_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "pathname",   null: false
    t.json     "settings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "categories", ["pathname"], name: "index_categories_on_pathname", using: :btree

  create_table "categorizations", force: :cascade do |t|
    t.integer  "categorizable_id",   null: false
    t.integer  "category_id",        null: false
    t.json     "settings"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "categorizable_type"
  end

  add_index "categorizations", ["categorizable_id", "categorizable_type"], name: "index_categories_on_poly_id_and_poly_type", using: :btree
  add_index "categorizations", ["category_id"], name: "index_categorizations_on_category_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "commenter_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["commenter_id"], name: "index_comments_on_commenter_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.integer  "user_business_id"
    t.integer  "company_business_id"
    t.text     "private_details"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "read_by",                 default: [],    null: false, array: true
    t.boolean  "hide"
    t.string   "name"
    t.string   "tagline"
    t.string   "website_url"
    t.string   "facebook_id"
    t.string   "google_plus_id"
    t.string   "linkedin_id"
    t.string   "twitter_id"
    t.string   "youtube_id"
    t.text     "description"
    t.string   "citysearch_id"
    t.string   "instagram_id"
    t.string   "pinterest_id"
    t.string   "yelp_id"
    t.string   "foursquare_id"
    t.string   "zillow_id"
    t.string   "opentable_id"
    t.string   "trulia_id"
    t.string   "realtor_id"
    t.string   "tripadvisor_id"
    t.string   "houzz_id"
    t.boolean  "business_record_creator", default: false
  end

  create_table "company_list_categories", force: :cascade do |t|
    t.integer  "company_list_id"
    t.string   "label"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "position"
  end

  create_table "company_list_companies", force: :cascade do |t|
    t.integer  "company_list_id"
    t.integer  "company_list_category_id"
    t.integer  "company_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "company_lists", force: :cascade do |t|
    t.string  "name"
    t.integer "sort_by"
    t.integer "business_id"
  end

  add_index "company_lists", ["business_id"], name: "index_company_lists_on_business_id", using: :btree

  create_table "company_locations", force: :cascade do |t|
    t.integer  "company_id",                                                     null: false
    t.string   "name",                                                           null: false
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "phone_number"
    t.string   "email"
    t.text     "service_area"
    t.boolean  "hide_address",                                   default: false, null: false
    t.boolean  "hide_phone",                                     default: false, null: false
    t.boolean  "hide_email",                                     default: false, null: false
    t.boolean  "external_service_area",                          default: false, null: false
    t.decimal  "latitude",              precision: 10, scale: 6
    t.decimal  "longitude",             precision: 10, scale: 6
    t.json     "settings"
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
  end

  add_index "company_locations", ["company_id"], name: "index_company_locations_on_company_id", using: :btree

  create_table "complaints_emails", force: :cascade do |t|
    t.text     "user_agent"
    t.text     "email_address"
    t.text     "complaint_feedback_type"
    t.text     "feedback_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_companies", force: :cascade do |t|
    t.integer  "contact_id"
    t.integer  "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "contact_companies", ["company_id"], name: "index_contact_companies_on_company_id", using: :btree
  add_index "contact_companies", ["contact_id"], name: "index_contact_companies_on_contact_id", using: :btree

  create_table "contact_form_form_fields", force: :cascade do |t|
    t.string   "label"
    t.integer  "position"
    t.integer  "contact_form_id"
    t.integer  "form_field_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "required",        default: false
  end

  add_index "contact_form_form_fields", ["contact_form_id"], name: "index_contact_form_form_fields_on_contact_form_id", using: :btree
  add_index "contact_form_form_fields", ["form_field_id"], name: "index_contact_form_form_fields_on_form_field_id", using: :btree

  create_table "contact_forms", force: :cascade do |t|
    t.string   "name"
    t.integer  "business_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "uuid"
    t.integer  "company_list_id"
    t.string   "public_label"
    t.string   "layout"
    t.string   "public_description"
    t.boolean  "archived",           default: false
  end

  add_index "contact_forms", ["business_id"], name: "index_contact_forms_on_business_id", using: :btree
  add_index "contact_forms", ["company_list_id"], name: "index_contact_forms_on_company_list_id", using: :btree

  create_table "contact_messages", force: :cascade do |t|
    t.integer  "business_id",                         null: false
    t.string   "customer_first_name",                 null: false
    t.string   "customer_email",                      null: false
    t.text     "message",                             null: false
    t.json     "settings"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.text     "customer_phone"
    t.integer  "contact_id"
    t.boolean  "hide",                default: false, null: false
    t.integer  "read_by",             default: [],    null: false, array: true
    t.string   "customer_last_name"
  end

  add_index "contact_messages", ["business_id"], name: "index_contact_messages_on_business_id", using: :btree
  add_index "contact_messages", ["contact_id"], name: "index_contact_messages_on_contact_id", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.integer  "business_id",                     null: false
    t.string   "first_name"
    t.string   "email"
    t.text     "phone"
    t.text     "notes"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "hide",            default: false, null: false
    t.integer  "read_by",         default: [],    null: false, array: true
    t.boolean  "business_client", default: false, null: false
    t.text     "business_name"
    t.text     "business_url"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.text     "relationship"
    t.text     "description"
    t.string   "last_name"
  end

  add_index "contacts", ["business_id"], name: "index_contacts_on_business_id", using: :btree

  create_table "content_categories", force: :cascade do |t|
    t.integer  "business_id", null: false
    t.text     "name",        null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "content_categories", ["business_id"], name: "index_content_categories_on_business_id", using: :btree

  create_table "content_categorizations", force: :cascade do |t|
    t.integer  "content_category_id", null: false
    t.integer  "content_item_id"
    t.string   "content_item_type"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "content_categorizations", ["content_category_id"], name: "index_content_categorizations_on_content_category_id", using: :btree
  add_index "content_categorizations", ["content_item_type", "content_item_id"], name: "index_content_categorizations_on_polymorphic_content_item", using: :btree

  create_table "content_feed_widget_content_categories", force: :cascade do |t|
    t.integer  "content_feed_widget_id"
    t.integer  "content_category_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "content_feed_widget_content_categories", ["content_category_id"], name: "content_fwidget_on_cats_idx", using: :btree
  add_index "content_feed_widget_content_categories", ["content_feed_widget_id"], name: "content_fwidget_cats_on_fwidget_idx", using: :btree

  create_table "content_feed_widget_content_tags", force: :cascade do |t|
    t.integer  "content_feed_widget_id"
    t.integer  "content_tag_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "content_feed_widget_content_tags", ["content_feed_widget_id"], name: "content_fwidget_tags_on_fwidget_idx", using: :btree
  add_index "content_feed_widget_content_tags", ["content_tag_id"], name: "content_fwidget_on_tags_idx", using: :btree

  create_table "content_feed_widgets", force: :cascade do |t|
    t.string   "name"
    t.string   "public_label"
    t.string   "uuid"
    t.integer  "business_id"
    t.integer  "max_items"
    t.string   "link_label"
    t.boolean  "enable_search"
    t.string   "content_types",                                array: true
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.text     "company_list_ids", default: [],                array: true
    t.boolean  "show_our_content", default: true
  end

  add_index "content_feed_widgets", ["business_id"], name: "index_content_feed_widgets_on_business_id", using: :btree

  create_table "content_taggings", force: :cascade do |t|
    t.integer  "content_item_id",   null: false
    t.string   "content_item_type", null: false
    t.integer  "content_tag_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "content_taggings", ["content_item_type", "content_item_id"], name: "index_content_taggings_on_content_item_type_and_content_item_id", using: :btree
  add_index "content_taggings", ["content_tag_id"], name: "index_content_taggings_on_content_tag_id", using: :btree

  create_table "content_tags", force: :cascade do |t|
    t.integer  "business_id", null: false
    t.text     "name",        null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "content_tags", ["business_id"], name: "index_content_tags_on_business_id", using: :btree

  create_table "crm_notes", force: :cascade do |t|
    t.integer  "contact_id"
    t.text     "content",    null: false
    t.text     "user_name",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "company_id"
  end

  add_index "crm_notes", ["company_id"], name: "index_crm_notes_on_company_id", using: :btree
  add_index "crm_notes", ["contact_id"], name: "index_crm_notes_on_contact_id", using: :btree

  create_table "directory_widgets", force: :cascade do |t|
    t.string   "name"
    t.integer  "business_id"
    t.integer  "company_list_id"
    t.string   "background_color"
    t.string   "uuid"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.boolean  "enable_search"
    t.string   "public_label"
  end

  add_index "directory_widgets", ["business_id"], name: "index_directory_widgets_on_business_id", using: :btree
  add_index "directory_widgets", ["company_list_id"], name: "index_directory_widgets_on_company_list_id", using: :btree

  create_table "event_definition_locations", force: :cascade do |t|
    t.integer  "event_definition_id", null: false
    t.integer  "location_id",         null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "event_definition_locations", ["event_definition_id"], name: "index_event_definition_locations_on_event_definition_id", using: :btree
  add_index "event_definition_locations", ["location_id"], name: "index_event_definition_locations_on_location_id", using: :btree

  create_table "event_definitions", force: :cascade do |t|
    t.integer  "business_id",                       null: false
    t.text     "title",                             null: false
    t.text     "subtitle"
    t.text     "description"
    t.text     "price"
    t.text     "url"
    t.text     "phone"
    t.text     "repetition"
    t.date     "start_date"
    t.date     "end_date"
    t.time     "start_time"
    t.time     "end_time"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.text     "external_type"
    t.text     "external_id"
    t.text     "meta_description"
    t.text     "facebook_id"
    t.text     "slug"
    t.boolean  "published_status"
    t.boolean  "hide_full_address", default: false
    t.boolean  "show_city_only",    default: false
    t.boolean  "private",           default: false
    t.boolean  "virtual_event",     default: false
    t.boolean  "rsvp_required",     default: false
    t.integer  "kind",              default: 0,     null: false
    t.text     "embed"
  end

  add_index "event_definitions", ["business_id"], name: "index_event_definitions_on_business_id", using: :btree
  add_index "event_definitions", ["id", "slug"], name: "index_event_definitions_on_id_and_slug", unique: true, using: :btree

  create_table "events", force: :cascade do |t|
    t.integer  "business_id",         null: false
    t.integer  "event_definition_id", null: false
    t.date     "occurs_on"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "events", ["business_id"], name: "index_events_on_business_id", using: :btree
  add_index "events", ["event_definition_id"], name: "index_events_on_event_definition_id", using: :btree

  create_table "feedbacks", force: :cascade do |t|
    t.integer  "business_id",                  null: false
    t.integer  "contact_id",                   null: false
    t.text     "token",                        null: false
    t.datetime "completed_at"
    t.date     "serviced_at"
    t.integer  "score"
    t.text     "description"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "hide",         default: false, null: false
    t.integer  "read_by",      default: [],    null: false, array: true
    t.integer  "company_id"
  end

  add_index "feedbacks", ["business_id"], name: "index_feedbacks_on_business_id", using: :btree
  add_index "feedbacks", ["company_id"], name: "index_feedbacks_on_company_id", using: :btree
  add_index "feedbacks", ["contact_id"], name: "index_feedbacks_on_contact_id", using: :btree

  create_table "form_fields", force: :cascade do |t|
    t.string   "name"
    t.string   "label"
    t.string   "contact_field"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "default",       default: false
    t.string   "field_type"
    t.boolean  "required",      default: false
  end

  create_table "form_submission_values", force: :cascade do |t|
    t.integer  "form_submission_id"
    t.integer  "contact_form_form_field_id"
    t.string   "value"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "form_submission_values", ["contact_form_form_field_id"], name: "index_form_submission_values_on_contact_form_form_field_id", using: :btree
  add_index "form_submission_values", ["form_submission_id"], name: "index_form_submission_values_on_form_submission_id", using: :btree

  create_table "form_submissions", force: :cascade do |t|
    t.integer  "contact_form_id"
    t.integer  "contact_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "business_id"
    t.integer  "read_by",         default: [], null: false, array: true
  end

  add_index "form_submissions", ["contact_form_id"], name: "index_form_submissions_on_contact_form_id", using: :btree
  add_index "form_submissions", ["contact_id"], name: "index_form_submissions_on_contact_id", using: :btree

  create_table "galleries", force: :cascade do |t|
    t.integer  "business_id",      null: false
    t.text     "title",            null: false
    t.text     "description"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "meta_description"
    t.text     "facebook_id"
    t.text     "slug"
    t.time     "published_time"
    t.boolean  "published_status"
    t.datetime "published_on"
  end

  add_index "galleries", ["business_id"], name: "index_galleries_on_business_id", using: :btree
  add_index "galleries", ["id", "slug"], name: "index_galleries_on_id_and_slug", unique: true, using: :btree

  create_table "gallery_images", force: :cascade do |t|
    t.integer  "gallery_id",              null: false
    t.text     "description"
    t.integer  "position",    default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.text     "title"
  end

  add_index "gallery_images", ["gallery_id"], name: "index_gallery_images_on_gallery_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.integer  "webpage_id",             null: false
    t.text     "type",                   null: false
    t.integer  "position",   default: 0, null: false
    t.integer  "max_blocks"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "kind",       default: 0, null: false
    t.json     "settings"
  end

  add_index "groups", ["webpage_id"], name: "index_groups_on_webpage_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.integer  "business_id",             null: false
    t.integer  "user_id",                 null: false
    t.string   "alt"
    t.string   "title"
    t.string   "attachment_cache_url"
    t.string   "attachment_content_type"
    t.string   "attachment_file_name"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.json     "settings"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.text     "processed_styles"
  end

  add_index "images", ["business_id"], name: "index_images_on_business_id", using: :btree
  add_index "images", ["user_id"], name: "index_images_on_user_id", using: :btree

  create_table "invites", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "invitee_id"
    t.integer  "inviter_id",                       null: false
    t.string   "message"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "invite_as_member", default: false
    t.string   "type_of"
    t.boolean  "skip_company",     default: false
  end

  create_table "job_locations", force: :cascade do |t|
    t.integer  "job_id",      null: false
    t.integer  "location_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "job_locations", ["job_id"], name: "index_job_locations_on_job_id", using: :btree
  add_index "job_locations", ["location_id"], name: "index_job_locations_on_location_id", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.integer  "business_id",                        null: false
    t.text     "title",                              null: false
    t.text     "subtitle"
    t.text     "description"
    t.text     "url"
    t.text     "phone"
    t.date     "start_date"
    t.date     "end_date"
    t.time     "start_time"
    t.time     "end_time"
    t.text     "external_type"
    t.text     "external_id"
    t.text     "meta_description"
    t.text     "facebook_id"
    t.text     "slug"
    t.boolean  "published_status"
    t.boolean  "hide_full_address",  default: false
    t.boolean  "show_city_only",     default: false
    t.boolean  "private",            default: false
    t.boolean  "virtual_event",      default: false
    t.integer  "kind",               default: 0,     null: false
    t.integer  "compensation_type",  default: 0
    t.text     "compensation_range"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "schedule_type",      default: 0,     null: false
  end

  add_index "jobs", ["business_id"], name: "index_jobs_on_business_id", using: :btree
  add_index "jobs", ["id", "slug"], name: "index_jobs_on_id_and_slug", unique: true, using: :btree

  create_table "line_images", force: :cascade do |t|
    t.integer  "line_id",                null: false
    t.integer  "position",   default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "line_images", ["line_id"], name: "index_line_images_on_line_id", using: :btree

  create_table "lines", force: :cascade do |t|
    t.integer  "business_id"
    t.text     "type",                 null: false
    t.text     "title",                null: false
    t.text     "description"
    t.text     "delivery_experience"
    t.text     "delivery_process"
    t.text     "uniqueness"
    t.text     "customer_description"
    t.text     "customer_problem"
    t.text     "customer_benefit"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "lines", ["business_id"], name: "index_lines_on_business_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.integer  "business_id",                           null: false
    t.string   "name",                                  null: false
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "phone_number"
    t.string   "email"
    t.text     "service_area"
    t.boolean  "hide_address",          default: false, null: false
    t.boolean  "hide_phone",            default: false, null: false
    t.boolean  "hide_email",            default: false, null: false
    t.boolean  "external_service_area", default: false, null: false
    t.float    "latitude"
    t.float    "longitude"
    t.json     "settings"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "locations", ["business_id"], name: "index_locations_on_business_id", using: :btree

  create_table "mailkick_opt_outs", force: :cascade do |t|
    t.string   "email"
    t.integer  "user_id"
    t.string   "user_type"
    t.boolean  "active",     default: true, null: false
    t.string   "reason"
    t.string   "list"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mailkick_opt_outs", ["email"], name: "index_mailkick_opt_outs_on_email", using: :btree
  add_index "mailkick_opt_outs", ["user_id", "user_type"], name: "index_mailkick_opt_outs_on_user_id_and_user_type", using: :btree

  create_table "mission_histories", force: :cascade do |t|
    t.integer  "actor_id"
    t.string   "action"
    t.text     "description"
    t.datetime "happened_at"
    t.integer  "mission_instance_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "trackable_type"
    t.integer  "trackable_id"
  end

  add_index "mission_histories", ["actor_id"], name: "index_mission_histories_on_actor_id", using: :btree
  add_index "mission_histories", ["mission_instance_id"], name: "index_mission_histories_on_mission_instance_id", using: :btree
  add_index "mission_histories", ["trackable_id"], name: "index_mission_histories_on_trackable_id", using: :btree
  add_index "mission_histories", ["trackable_type"], name: "index_mission_histories_on_trackable_type", using: :btree

  create_table "mission_instance_events", force: :cascade do |t|
    t.integer  "business_id"
    t.integer  "mission_instance_id"
    t.date     "occurs_on"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "status",              default: 0
  end

  add_index "mission_instance_events", ["business_id"], name: "index_mission_instance_events_on_business_id", using: :btree
  add_index "mission_instance_events", ["mission_instance_id"], name: "index_mission_instance_events_on_mission_instance_id", using: :btree

  create_table "mission_instances", force: :cascade do |t|
    t.integer  "business_id"
    t.integer  "status"
    t.integer  "mission_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "last_completed_at"
    t.datetime "last_snoozed_at"
    t.datetime "last_skipped_at"
    t.integer  "last_status",        default: 0
    t.integer  "completion_times",   default: 0
    t.integer  "incompletion_times", default: 0
    t.integer  "total_times",        default: 0
    t.integer  "assigned_user_id"
    t.integer  "creating_user_id"
    t.text     "repetition"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "activated_at"
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "to_do_list_id"
    t.boolean  "excluded_from_list"
  end

  add_index "mission_instances", ["assigned_user_id"], name: "index_mission_instances_on_assigned_user_id", using: :btree
  add_index "mission_instances", ["business_id"], name: "index_mission_instances_on_business_id", using: :btree
  add_index "mission_instances", ["creating_user_id"], name: "index_mission_instances_on_creating_user_id", using: :btree
  add_index "mission_instances", ["mission_id"], name: "index_mission_instances_on_mission_id", using: :btree
  add_index "mission_instances", ["to_do_list_id"], name: "index_mission_instances_on_to_do_list_id", using: :btree

  create_table "mission_notification_settings", force: :cascade do |t|
    t.integer  "business_id"
    t.boolean  "weeky_due_notification",             default: true
    t.boolean  "daily_due_notification",             default: true
    t.boolean  "summary_notification",               default: true
    t.boolean  "suggestions_notification",           default: true
    t.boolean  "comment_notification",               default: true
    t.datetime "created_at",                                                                                                                                                        null: false
    t.datetime "updated_at",                                                                                                                                                        null: false
    t.text     "summary_frequency"
    t.text     "suggestions_frequency",              default: "{\"interval\":1,\"until\":null,\"count\":null,\"validations\":{\"day\":[1]},\"rule_type\":\"IceCube::WeeklyRule\"}"
    t.integer  "user_id"
    t.integer  "daily_due_notification_preference",  default: 0
    t.integer  "weekly_due_notification_preference", default: 0
  end

  add_index "mission_notification_settings", ["business_id"], name: "index_mission_notification_settings_on_business_id", using: :btree

  create_table "missions", force: :cascade do |t|
    t.integer  "to_do_list_id"
    t.integer  "status",                default: 0
    t.integer  "prompt_type",           default: 0
    t.text     "description"
    t.text     "benefits"
    t.string   "time_to_complete"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "title"
    t.string   "group"
    t.string   "tier"
    t.string   "difficulty"
    t.jsonb    "pillars"
    t.text     "success_tips"
    t.jsonb    "industry"
    t.integer  "target_frequency_days"
    t.integer  "alert_frequency_days"
    t.jsonb    "settings"
    t.integer  "business_id"
    t.text     "repetition"
    t.boolean  "globally_recommended",  default: false
  end

  add_index "missions", ["business_id"], name: "index_missions_on_business_id", using: :btree
  add_index "missions", ["to_do_list_id"], name: "index_missions_on_to_do_list_id", using: :btree

  create_table "nav_links", force: :cascade do |t|
    t.integer  "website_id",             null: false
    t.integer  "webpage_id"
    t.text     "ancestry"
    t.text     "label"
    t.text     "url"
    t.integer  "location",   default: 0, null: false
    t.integer  "kind",       default: 0, null: false
    t.integer  "position"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.text     "webpath"
  end

  add_index "nav_links", ["webpage_id"], name: "index_nav_links_on_webpage_id", using: :btree
  add_index "nav_links", ["website_id"], name: "index_nav_links_on_website_id", using: :btree

  create_table "notes", force: :cascade do |t|
    t.text     "note"
    t.string   "notable_type"
    t.integer  "notable_id"
    t.integer  "author_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "notes", ["author_id"], name: "index_notes_on_author_id", using: :btree
  add_index "notes", ["notable_id"], name: "index_notes_on_notable_id", using: :btree
  add_index "notes", ["notable_type"], name: "index_notes_on_notable_type", using: :btree

  create_table "offers", force: :cascade do |t|
    t.integer  "business_id",                     null: false
    t.text     "title",                           null: false
    t.text     "offer",                           null: false
    t.text     "description"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "kind",                default: 0, null: false
    t.date     "valid_until"
    t.text     "offer_code"
    t.text     "terms"
    t.text     "coupon_content_type"
    t.text     "coupon_file_name"
    t.integer  "coupon_file_size"
    t.datetime "coupon_updated_at"
    t.text     "meta_description"
    t.text     "facebook_id"
    t.text     "slug"
    t.time     "published_time"
    t.boolean  "published_status"
    t.datetime "published_on"
  end

  add_index "offers", ["business_id"], name: "index_offers_on_business_id", using: :btree
  add_index "offers", ["id", "slug"], name: "index_offers_on_id_and_slug", unique: true, using: :btree

  create_table "openings", force: :cascade do |t|
    t.integer  "location_id",                 null: false
    t.time     "opens_at"
    t.time     "closes_at"
    t.boolean  "sunday",      default: false, null: false
    t.boolean  "monday",      default: false, null: false
    t.boolean  "tuesday",     default: false, null: false
    t.boolean  "wednesday",   default: false, null: false
    t.boolean  "thursday",    default: false, null: false
    t.boolean  "friday",      default: false, null: false
    t.boolean  "saturday",    default: false, null: false
    t.json     "settings"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "by_appt"
  end

  add_index "openings", ["location_id"], name: "index_openings_on_location_id", using: :btree

  create_table "pdfs", force: :cascade do |t|
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "user_id"
    t.integer  "business_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "pdfs", ["business_id"], name: "index_pdfs_on_business_id", using: :btree
  add_index "pdfs", ["user_id"], name: "index_pdfs_on_user_id", using: :btree

  create_table "placements", force: :cascade do |t|
    t.integer  "placer_id",                   null: false
    t.string   "placer_type",                 null: false
    t.integer  "image_id"
    t.string   "context",     default: "",    null: false
    t.string   "style",       default: "",    null: false
    t.json     "settings"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.text     "embed"
    t.integer  "kind",        default: 0,     null: false
    t.boolean  "full_width",  default: false, null: false
  end

  add_index "placements", ["image_id"], name: "index_placements_on_image_id", using: :btree
  add_index "placements", ["placer_type", "placer_id"], name: "index_placements_on_placer_type_and_placer_id", using: :btree

  create_table "post_sections", force: :cascade do |t|
    t.integer  "post_id"
    t.text     "heading",    null: false
    t.text     "content"
    t.text     "ancestry"
    t.integer  "kind",       null: false
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "post_sections", ["post_id"], name: "index_post_sections_on_post_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "business_id",      null: false
    t.text     "title",            null: false
    t.text     "description"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "meta_description"
    t.text     "facebook_id"
    t.text     "slug"
    t.datetime "published_time"
    t.boolean  "published_status"
    t.datetime "published_on"
  end

  add_index "posts", ["business_id"], name: "index_posts_on_business_id", using: :btree
  add_index "posts", ["id", "slug"], name: "index_posts_on_id_and_slug", unique: true, using: :btree

  create_table "quick_posts", force: :cascade do |t|
    t.integer  "business_id"
    t.text     "title"
    t.text     "content"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "meta_description"
    t.text     "facebook_id"
    t.text     "slug"
    t.datetime "published_time"
    t.boolean  "published_status"
    t.datetime "published_on"
  end

  add_index "quick_posts", ["business_id"], name: "index_quick_posts_on_business_id", using: :btree
  add_index "quick_posts", ["id", "slug"], name: "index_quick_posts_on_id_and_slug", unique: true, using: :btree

  create_table "redirects", force: :cascade do |t|
    t.integer  "website_id", null: false
    t.text     "from_path",  null: false
    t.text     "to_path",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "redirects", ["website_id"], name: "index_redirects_on_website_id", using: :btree

  create_table "review_widgets", force: :cascade do |t|
    t.string   "uuid"
    t.string   "name"
    t.text     "description"
    t.text     "settings"
    t.integer  "business_id"
    t.string   "layout"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "label"
  end

  add_index "review_widgets", ["business_id"], name: "index_review_widgets_on_business_id", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.integer  "business_id",                                            null: false
    t.text     "external_id"
    t.text     "external_name"
    t.text     "external_type"
    t.text     "external_url"
    t.text     "title"
    t.text     "description",                                            null: false
    t.decimal  "overall_rating", precision: 2, scale: 1,                 null: false
    t.datetime "reviewed_at",                                            null: false
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.decimal  "quality_rating", precision: 2, scale: 1
    t.decimal  "service_rating", precision: 2, scale: 1
    t.decimal  "value_rating",   precision: 2, scale: 1
    t.text     "customer_name"
    t.text     "customer_email"
    t.text     "customer_phone"
    t.integer  "contact_id"
    t.boolean  "published",                              default: false, null: false
    t.date     "serviced_at"
    t.integer  "feedback_id"
    t.boolean  "hide",                                   default: false, null: false
    t.integer  "read_by",                                default: [],    null: false, array: true
    t.text     "facebook_id"
    t.integer  "company_id"
  end

  add_index "reviews", ["business_id"], name: "index_reviews_on_business_id", using: :btree
  add_index "reviews", ["company_id"], name: "index_reviews_on_company_id", using: :btree
  add_index "reviews", ["contact_id"], name: "index_reviews_on_contact_id", using: :btree

  create_table "schedules", force: :cascade do |t|
    t.integer  "share_id"
    t.datetime "share_times", default: [], array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shares", force: :cascade do |t|
    t.text     "message"
    t.integer  "shareable_id"
    t.string   "shareable_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.text     "facebook_id"
  end

  add_index "shares", ["shareable_type", "shareable_id"], name: "index_shares_on_shareable_type_and_shareable_id", using: :btree

  create_table "subscription_affiliates", force: :cascade do |t|
    t.string   "name"
    t.decimal  "rate",        precision: 6, scale: 4, default: 0.2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.integer  "business_id"
  end

  add_index "subscription_affiliates", ["token"], name: "index_subscription_affiliates_on_token", using: :btree

  create_table "subscription_discounts", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.decimal  "amount",                 precision: 6, scale: 2, default: 0.0
    t.boolean  "percent"
    t.date     "start_on"
    t.date     "end_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "apply_to_setup",                                 default: true
    t.boolean  "apply_to_recurring",                             default: true
    t.integer  "trial_period_extension",                         default: 0
  end

  create_table "subscription_payments", force: :cascade do |t|
    t.integer  "subscription_id"
    t.decimal  "amount",                    precision: 10, scale: 2, default: 0.0
    t.string   "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "misc"
    t.integer  "subscription_affiliate_id"
    t.decimal  "affiliate_amount",          precision: 6,  scale: 2, default: 0.0
    t.integer  "subscriber_id"
    t.string   "subscriber_type"
    t.boolean  "monthly",                                            default: false
    t.boolean  "annual",                                             default: false
    t.boolean  "setup",                                              default: false
  end

  add_index "subscription_payments", ["subscriber_id", "subscriber_type"], name: "index_payments_on_subscriber", using: :btree
  add_index "subscription_payments", ["subscription_id"], name: "index_subscription_payments_on_subscription_id", using: :btree

  create_table "subscription_plans", force: :cascade do |t|
    t.string   "name"
    t.decimal  "amount",         precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "renewal_period",                          default: 1
    t.decimal  "setup_amount",   precision: 10, scale: 2
    t.integer  "trial_period",                            default: 0
    t.string   "trial_interval",                          default: "months"
    t.integer  "user_limit"
    t.text     "setup_name",                              default: "N/A"
    t.decimal  "amount_annual",  precision: 10, scale: 2, default: 0.0
    t.text     "description"
    t.boolean  "activated"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.decimal  "amount",                    precision: 10, scale: 2
    t.datetime "next_renewal_at"
    t.string   "card_number"
    t.string   "card_expiration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                              default: "inactive"
    t.integer  "subscription_plan_id"
    t.integer  "subscriber_id"
    t.string   "subscriber_type"
    t.integer  "renewal_period",                                     default: 1
    t.string   "billing_id"
    t.integer  "subscription_discount_id"
    t.integer  "subscription_affiliate_id"
    t.integer  "user_limit"
    t.boolean  "annual",                                             default: false
    t.integer  "downgrade_to"
    t.integer  "upgrade_to"
    t.boolean  "flagged_for_annual",                                 default: false
  end

  add_index "subscriptions", ["subscriber_id", "subscriber_type"], name: "index_subscriptions_on_subscriber", using: :btree

  create_table "team_members", force: :cascade do |t|
    t.integer  "business_id",                null: false
    t.integer  "position",       default: 0
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "title"
    t.string   "description"
    t.string   "facebook_id"
    t.string   "google_plus_id"
    t.string   "linkedin_id"
    t.string   "twitter_id"
    t.json     "settings"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "team_members", ["business_id"], name: "index_team_members_on_business_id", using: :btree

  create_table "to_do_comments", force: :cascade do |t|
    t.integer  "commenter_id"
    t.integer  "to_do_id"
    t.text     "content"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "to_do_comments", ["commenter_id"], name: "index_to_do_comments_on_commenter_id", using: :btree
  add_index "to_do_comments", ["to_do_id"], name: "index_to_do_comments_on_to_do_id", using: :btree

  create_table "to_do_lists", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "business_id"
  end

  add_index "to_do_lists", ["business_id"], name: "index_to_do_lists_on_business_id", using: :btree

  create_table "to_do_notification_settings", force: :cascade do |t|
    t.boolean  "assigned",                  default: true
    t.boolean  "updates_or_comments",       default: true
    t.boolean  "deadline_approaching",      default: true
    t.boolean  "due",                       default: true
    t.boolean  "accepted",                  default: true
    t.integer  "overdue_reminder_interval", default: 0
    t.integer  "business_id"
    t.integer  "user_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "to_do_notification_settings", ["business_id"], name: "index_to_do_notification_settings_on_business_id", using: :btree
  add_index "to_do_notification_settings", ["user_id"], name: "index_to_do_notification_settings_on_user_id", using: :btree

  create_table "to_dos", force: :cascade do |t|
    t.integer  "business_id"
    t.text     "title"
    t.text     "description"
    t.integer  "submission_status", default: 0
    t.integer  "status",            default: 0
    t.datetime "due_date"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "group",             default: 0
  end

  add_index "to_dos", ["business_id"], name: "index_to_dos_on_business_id", using: :btree

  create_table "track_rake_create_companies", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "company_location_id"
    t.integer  "business_id"
    t.integer  "location_id"
    t.integer  "contact_company_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "track_rake_create_companies", ["business_id"], name: "index_track_rake_create_companies_on_business_id", using: :btree
  add_index "track_rake_create_companies", ["company_id"], name: "index_track_rake_create_companies_on_company_id", using: :btree
  add_index "track_rake_create_companies", ["company_location_id"], name: "index_track_rake_create_companies_on_company_location_id", using: :btree
  add_index "track_rake_create_companies", ["contact_company_id"], name: "index_track_rake_create_companies_on_contact_company_id", using: :btree
  add_index "track_rake_create_companies", ["location_id"], name: "index_track_rake_create_companies_on_location_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",                                null: false
    t.string   "last_name",                                 null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "email",                     default: "",    null: false
    t.string   "encrypted_password",        default: "",    null: false
    t.integer  "failed_attempts",           default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.json     "settings"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "super_user",                default: false, null: false
    t.integer  "cce_id"
    t.boolean  "app_marketing_reminders",   default: true,  null: false
    t.boolean  "email_marketing_reminders", default: true,  null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "webhosts", force: :cascade do |t|
    t.integer  "website_id",                 null: false
    t.string   "name",                       null: false
    t.boolean  "primary",    default: false, null: false
    t.json     "settings"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "webhosts", ["name"], name: "index_webhosts_on_name", unique: true, using: :btree
  add_index "webhosts", ["website_id"], name: "index_webhosts_on_website_id", using: :btree

  create_table "webpages", force: :cascade do |t|
    t.integer  "website_id",                  null: false
    t.boolean  "active",      default: false, null: false
    t.string   "type",                        null: false
    t.string   "pathname",    default: "",    null: false
    t.string   "name",                        null: false
    t.string   "title",                       null: false
    t.string   "description"
    t.json     "settings"
    t.text     "custom_css"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "webpages", ["website_id", "pathname"], name: "index_webpages_on_website_id_and_pathname", unique: true, using: :btree
  add_index "webpages", ["website_id"], name: "index_webpages_on_website_id", using: :btree

  create_table "websites", force: :cascade do |t|
    t.integer  "business_id",                                    null: false
    t.string   "subdomain",                                      null: false
    t.text     "custom_css"
    t.json     "settings"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.json     "header_menu"
    t.json     "footer_menu"
    t.boolean  "content_blog_sidebar",            default: true, null: false
    t.boolean  "events_sidebar",                  default: true, null: false
    t.boolean  "content_blog_sidebar_on_reviews", default: true, null: false
    t.text     "footer_embed"
    t.boolean  "hide_embed_on_landing"
    t.boolean  "hide_embed_on_blog"
    t.text     "header_embed"
    t.boolean  "hide_header_embed_on_landing"
    t.boolean  "hide_header_embed_on_blog"
  end

  add_index "websites", ["business_id"], name: "index_websites_on_business_id", using: :btree
  add_index "websites", ["subdomain"], name: "index_websites_on_subdomain", unique: true, using: :btree

  add_foreign_key "contact_form_form_fields", "contact_forms"
  add_foreign_key "contact_form_form_fields", "form_fields"
  add_foreign_key "contact_forms", "businesses"
  add_foreign_key "form_submissions", "contact_forms"
  add_foreign_key "form_submissions", "contacts"
  add_foreign_key "lines", "businesses"
  add_foreign_key "pdfs", "businesses"
  add_foreign_key "pdfs", "users"
  add_foreign_key "post_sections", "posts"
  add_foreign_key "quick_posts", "businesses"
  add_foreign_key "review_widgets", "businesses"
end
