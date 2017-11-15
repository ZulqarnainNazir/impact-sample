class Job < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.references :business, index: true, null: false
      t.integer  "business_id", null: false
      t.text     "title",       null: false
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
      t.boolean  "hide_full_address", default: false
      t.boolean  "show_city_only",    default: false
      t.boolean  "private",           default: false
      t.boolean  "virtual_event",     default: false
      t.integer  "kind",              default: 0,     null: false
      t.integer :compensation_type, default: 0
      t.text :compensation_range
      t.timestamps null: false
    end

    add_index "jobs", ["id", "slug"], name: "index_jobs_on_id_and_slug", unique: true, using: :btree

  end
end
