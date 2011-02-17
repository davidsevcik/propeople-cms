# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091003095744) do

  create_table "audit_events", :force => true do |t|
    t.string   "auditable_type"
    t.integer  "auditable_id"
    t.integer  "user_id"
    t.string   "ip_address"
    t.integer  "audit_type_id"
    t.text     "log_message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "audit_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "config", :force => true do |t|
    t.string  "key",                :limit => 40, :default => "",    :null => false
    t.string  "value",                            :default => ""
    t.text    "description"
    t.boolean "is_hidden_for_user",               :default => false
  end

  add_index "config", ["key"], :name => "key", :unique => true

  create_table "extension_meta", :force => true do |t|
    t.string  "name"
    t.integer "schema_version", :default => 0
    t.boolean "enabled",        :default => true
  end

  create_table "layouts", :force => true do |t|
    t.string   "name",          :limit => 100
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.string   "content_type",  :limit => 40
    t.integer  "lock_version",                 :default => 0
  end

  create_table "multilingual_groups", :force => true do |t|
  end

  create_table "page_attachments", :force => true do |t|
    t.string   "content_type"
    t.string   "filename"
    t.integer  "size"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.integer  "created_by"
    t.datetime "updated_at"
    t.integer  "updated_by"
    t.integer  "page_id"
    t.string   "title"
    t.string   "description"
    t.integer  "position"
    t.string   "flag"
    t.boolean  "copy_to_translation", :default => true
  end

  create_table "page_fields", :force => true do |t|
    t.integer "page_id"
    t.string  "name"
    t.text    "content"
    t.string  "caption"
    t.boolean "erasable", :default => true, :null => false
  end

  add_index "page_fields", ["page_id"], :name => "index_page_fields_on_page_id"

  create_table "page_parts", :force => true do |t|
    t.string   "name",             :limit => 100
    t.string   "filter_id",        :limit => 25
    t.text     "content"
    t.integer  "page_id"
    t.string   "page_part_type"
    t.string   "string_content"
    t.boolean  "boolean_content"
    t.integer  "integer_content"
    t.datetime "datetime_content"
    t.string   "title"
    t.integer  "position"
  end

  add_index "page_parts", ["boolean_content"], :name => "index_page_parts_on_boolean_content"
  add_index "page_parts", ["datetime_content"], :name => "index_page_parts_on_datetime_content"
  add_index "page_parts", ["integer_content"], :name => "index_page_parts_on_integer_content"
  add_index "page_parts", ["page_id", "name"], :name => "parts_by_page"
  add_index "page_parts", ["string_content"], :name => "index_page_parts_on_string_content"

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "slug",                  :limit => 100
    t.string   "breadcrumb",            :limit => 160
    t.string   "class_name",            :limit => 25
    t.integer  "status_id",                            :default => 1,     :null => false
    t.integer  "parent_id"
    t.integer  "layout_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.boolean  "virtual",                              :default => false, :null => false
    t.integer  "lock_version",                         :default => 0
    t.boolean  "show_in_menu",                         :default => true
    t.integer  "site_id"
    t.integer  "multilingual_group_id"
    t.integer  "position",                             :default => 0
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "redirect"
    t.string   "system_name"
  end

  add_index "pages", ["class_name"], :name => "pages_class_name"
  add_index "pages", ["multilingual_group_id"], :name => "index_pages_on_multilingual_group_id"
  add_index "pages", ["parent_id"], :name => "pages_parent_id"
  add_index "pages", ["site_id"], :name => "index_pages_on_site_id"
  add_index "pages", ["slug", "parent_id"], :name => "pages_child_slug"
  add_index "pages", ["virtual", "status_id"], :name => "pages_published"

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "sites", :force => true do |t|
    t.string  "name"
    t.string  "domain"
    t.integer "homepage_id"
    t.integer "position",    :default => 0
    t.string  "base_domain"
    t.string  "language"
  end

  create_table "snippets", :force => true do |t|
    t.string   "name",          :limit => 100, :default => "", :null => false
    t.string   "filter_id",     :limit => 25
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.integer  "lock_version",                 :default => 0
  end

  add_index "snippets", ["name"], :name => "name", :unique => true

  create_table "text_assets", :force => true do |t|
    t.string   "class_name",    :limit => 25
    t.string   "name",          :limit => 100
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.integer  "lock_version"
    t.string   "filter_id",     :limit => 25
  end

  add_index "text_assets", ["name", "class_name"], :name => "index_text_assets_on_name_and_class_name"

  create_table "users", :force => true do |t|
    t.string   "name",          :limit => 100
    t.string   "email"
    t.string   "login",         :limit => 40,  :default => "",    :null => false
    t.string   "password",      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.boolean  "admin",                        :default => false, :null => false
    t.boolean  "designer",                     :default => false, :null => false
    t.text     "notes"
    t.integer  "lock_version",                 :default => 0
    t.string   "salt"
    t.string   "session_token"
    t.string   "locale"
    t.string   "reference"
    t.string   "organization"
  end

  add_index "users", ["login"], :name => "login", :unique => true

end
