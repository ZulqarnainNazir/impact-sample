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

ActiveRecord::Schema.define(version: 20170110020537) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", force: :cascade do |t|
    t.integer  "business_id",                                  null: false
    t.integer  "user_id",                                      null: false
    t.integer  "role",                                         null: false
    t.json     "settings"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.boolean  "contact_message_notifications", default: true, null: false
    t.boolean  "review_notifications",          default: true, null: false
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
  end

  add_index "blocks", ["frame_type", "frame_id"], name: "index_blocks_on_frame_type_and_frame_id", using: :btree
  add_index "blocks", ["link_type", "link_id"], name: "index_blocks_on_link_type_and_link_id", using: :btree

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
    t.string   "name",                                 null: false
    t.string   "tagline"
    t.string   "website_url"
    t.string   "facebook_id"
    t.string   "google_plus_id"
    t.string   "linkedin_id"
    t.string   "twitter_id"
    t.string   "youtube_id"
    t.text     "description"
    t.integer  "kind",                  default: 0,    null: false
    t.integer  "year_founded"
    t.json     "settings"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "citysearch_id"
    t.string   "instagram_id"
    t.string   "pinterest_id"
    t.string   "yelp_id"
    t.text     "values"
    t.text     "history"
    t.text     "vision"
    t.text     "community_involvement"
    t.integer  "plan",                  default: 0,    null: false
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
    t.boolean  "in_impact",             default: true
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "pathname",   null: false
    t.json     "settings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "categories", ["pathname"], name: "index_categories_on_pathname", using: :btree

  create_table "categorizations", force: :cascade do |t|
    t.integer  "business_id", null: false
    t.integer  "category_id", null: false
    t.json     "settings"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "categorizations", ["business_id"], name: "index_categorizations_on_business_id", using: :btree
  add_index "categorizations", ["category_id"], name: "index_categorizations_on_category_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.integer  "user_business_id"
    t.integer  "company_business_id"
    t.text     "private_details"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "read_by",             default: [], null: false, array: true
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
  end

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

  create_table "contact_companies", force: :cascade do |t|
    t.integer  "contact_id"
    t.integer  "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "contact_companies", ["company_id"], name: "index_contact_companies_on_company_id", using: :btree
  add_index "contact_companies", ["contact_id"], name: "index_contact_companies_on_contact_id", using: :btree

  create_table "contact_messages", force: :cascade do |t|
    t.integer  "business_id",                    null: false
    t.string   "customer_name",                  null: false
    t.string   "customer_email",                 null: false
    t.text     "message",                        null: false
    t.json     "settings"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.text     "customer_phone"
    t.integer  "contact_id"
    t.boolean  "hide",           default: false, null: false
    t.integer  "read_by",        default: [],    null: false, array: true
  end

  add_index "contact_messages", ["business_id"], name: "index_contact_messages_on_business_id", using: :btree
  add_index "contact_messages", ["contact_id"], name: "index_contact_messages_on_contact_id", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.integer  "business_id",                     null: false
    t.text     "name",                            null: false
    t.text     "email",                           null: false
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

  create_table "event_definition_locations", force: :cascade do |t|
    t.integer  "event_definition_id", null: false
    t.integer  "location_id",         null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "event_definition_locations", ["event_definition_id"], name: "index_event_definition_locations_on_event_definition_id", using: :btree
  add_index "event_definition_locations", ["location_id"], name: "index_event_definition_locations_on_location_id", using: :btree

  create_table "event_definitions", force: :cascade do |t|
    t.integer  "business_id",      null: false
    t.text     "title",            null: false
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
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "external_type"
    t.text     "external_id"
    t.text     "meta_description"
    t.text     "facebook_id"
    t.text     "slug"
    t.boolean  "published_status"
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
    t.text     "cached_styles",                        array: true
    t.text     "processed_styles"
  end

  add_index "images", ["business_id"], name: "index_images_on_business_id", using: :btree
  add_index "images", ["user_id"], name: "index_images_on_user_id", using: :btree

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
    t.text     "title",                                                  null: false
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
  end

  add_index "websites", ["business_id"], name: "index_websites_on_business_id", using: :btree
  add_index "websites", ["subdomain"], name: "index_websites_on_subdomain", unique: true, using: :btree

  add_foreign_key "lines", "businesses"
  add_foreign_key "pdfs", "businesses"
  add_foreign_key "pdfs", "users"
  add_foreign_key "post_sections", "posts"
  add_foreign_key "quick_posts", "businesses"
  add_foreign_key "review_widgets", "businesses"
end
