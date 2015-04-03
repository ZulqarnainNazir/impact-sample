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

ActiveRecord::Schema.define(version: 17) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", force: :cascade do |t|
    t.integer  "business_id", null: false
    t.integer  "user_id",     null: false
    t.integer  "role",        null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "authorizations", ["business_id"], name: "index_authorizations_on_business_id", using: :btree
  add_index "authorizations", ["user_id"], name: "index_authorizations_on_user_id", using: :btree

  create_table "blocks", force: :cascade do |t|
    t.integer  "frame_id",                          null: false
    t.string   "frame_type",                        null: false
    t.integer  "link_id"
    t.string   "link_type"
    t.string   "type",                              null: false
    t.string   "theme"
    t.string   "style"
    t.string   "link_label"
    t.text     "heading"
    t.text     "subheading"
    t.text     "text"
    t.text     "link_external_url"
    t.boolean  "link_target_blank", default: false, null: false
    t.boolean  "link_no_follow",    default: false, null: false
    t.integer  "link_version",      default: 0,     null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.json     "settings"
    t.string   "spoof"
  end

  add_index "blocks", ["frame_type", "frame_id"], name: "index_blocks_on_frame_type_and_frame_id", using: :btree
  add_index "blocks", ["link_type", "link_id"], name: "index_blocks_on_link_type_and_link_id", using: :btree

  create_table "businesses", force: :cascade do |t|
    t.string   "name",                       null: false
    t.string   "tagline"
    t.string   "website_url"
    t.string   "facebook_id"
    t.string   "google_plus_id"
    t.string   "linkedin_id"
    t.string   "twitter_id"
    t.string   "youtube_id"
    t.text     "description"
    t.integer  "kind",           default: 0, null: false
    t.integer  "year_founded"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "pathname",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "categories", ["pathname"], name: "index_categories_on_pathname", using: :btree

  create_table "categorizations", force: :cascade do |t|
    t.integer  "business_id", null: false
    t.integer  "category_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "categorizations", ["business_id"], name: "index_categorizations_on_business_id", using: :btree
  add_index "categorizations", ["category_id"], name: "index_categorizations_on_category_id", using: :btree

  create_table "contact_messages", force: :cascade do |t|
    t.integer  "business_id", null: false
    t.string   "name",        null: false
    t.string   "email",       null: false
    t.text     "message",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "contact_messages", ["business_id"], name: "index_contact_messages_on_business_id", using: :btree

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
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "images", ["business_id"], name: "index_images_on_business_id", using: :btree
  add_index "images", ["user_id"], name: "index_images_on_user_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.integer  "business_id",                                                    null: false
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
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
  end

  add_index "locations", ["business_id"], name: "index_locations_on_business_id", using: :btree

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
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "openings", ["location_id"], name: "index_openings_on_location_id", using: :btree

  create_table "placements", force: :cascade do |t|
    t.integer  "placer_id",                null: false
    t.string   "placer_type",              null: false
    t.integer  "image_id",                 null: false
    t.string   "context",     default: "", null: false
    t.string   "style",       default: "", null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "placements", ["image_id"], name: "index_placements_on_image_id", using: :btree
  add_index "placements", ["placer_type", "placer_id"], name: "index_placements_on_placer_type_and_placer_id", using: :btree

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
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "team_members", ["business_id"], name: "index_team_members_on_business_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",                          null: false
    t.string   "last_name",                           null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "webhosts", force: :cascade do |t|
    t.integer  "website_id",                 null: false
    t.string   "name",                       null: false
    t.boolean  "primary",    default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "webhosts", ["name"], name: "index_webhosts_on_name", unique: true, using: :btree
  add_index "webhosts", ["website_id"], name: "index_webhosts_on_website_id", using: :btree

  create_table "webpages", force: :cascade do |t|
    t.integer "website_id",                  null: false
    t.boolean "active",      default: false, null: false
    t.string  "type",                        null: false
    t.string  "pathname",    default: "",    null: false
    t.string  "name",                        null: false
    t.string  "title",                       null: false
    t.string  "description"
    t.text    "custom_css"
  end

  add_index "webpages", ["website_id", "pathname"], name: "index_webpages_on_website_id_and_pathname", unique: true, using: :btree
  add_index "webpages", ["website_id"], name: "index_webpages_on_website_id", using: :btree

  create_table "websites", force: :cascade do |t|
    t.integer  "business_id", null: false
    t.string   "subdomain",   null: false
    t.text     "custom_css"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "websites", ["business_id"], name: "index_websites_on_business_id", using: :btree
  add_index "websites", ["subdomain"], name: "index_websites_on_subdomain", unique: true, using: :btree

end
