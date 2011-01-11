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

  create_table "news_categories", :force => true do |t|
    t.string "name"
  end

  create_table "news_entries", :force => true do |t|
    t.string   "headline"
    t.string   "leadtext"
    t.text     "text"
    t.date     "start"
    t.date     "stop"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "news_category_id"
  end

  create_table "news_entries_news_categories", :id => false, :force => true do |t|
    t.integer "news_entry_id"
    t.integer "news_category_id"
  end

  create_table "news_entries_news_tags", :id => false, :force => true do |t|
    t.integer "news_entry_id"
    t.integer "news_tag_id"
  end

  create_table "news_entry_pages", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_tags", :force => true do |t|
    t.string "name"
  end

  create_table "order_items", :force => true do |t|
    t.integer "product_page_id"
    t.integer "order_id"
    t.decimal "price",           :precision => 10, :scale => 2
    t.integer "quantity",                                       :default => 1
  end

  add_index "order_items", ["order_id"], :name => "index_order_items_on_order_id"
  add_index "order_items", ["product_page_id"], :name => "index_order_items_on_product_page_id"

  create_table "order_states", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "orders", :force => true do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "company"
    t.string   "email"
    t.string   "phone"
    t.string   "street"
    t.string   "city"
    t.string   "zip"
    t.string   "delivery_name"
    t.string   "delivery_surname"
    t.string   "delivery_street"
    t.string   "delivery_city"
    t.string   "delivery_zip"
    t.string   "delivery_phone"
    t.integer  "state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["state_id"], :name => "index_orders_on_state_id"

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
  end

  create_table "page_parts", :force => true do |t|
    t.string  "name",      :limit => 100
    t.string  "filter_id", :limit => 25
    t.text    "content"
    t.integer "page_id"
  end

  add_index "page_parts", ["page_id", "name"], :name => "parts_by_page"

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "slug",               :limit => 100
    t.string   "breadcrumb",         :limit => 160
    t.string   "class_name",         :limit => 25
    t.integer  "status_id",                         :default => 1,     :null => false
    t.integer  "parent_id"
    t.integer  "layout_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.boolean  "virtual",                           :default => false, :null => false
    t.integer  "lock_version",                      :default => 0
    t.string   "description"
    t.string   "keywords"
    t.boolean  "show_in_menu",                      :default => true
    t.integer  "position"
    t.integer  "multilingual_group"
  end

  add_index "pages", ["class_name"], :name => "pages_class_name"
  add_index "pages", ["multilingual_group"], :name => "index_pages_on_multilingual_group"
  add_index "pages", ["parent_id"], :name => "pages_parent_id"
  add_index "pages", ["slug", "parent_id"], :name => "pages_child_slug"
  add_index "pages", ["virtual", "status_id"], :name => "pages_published"

  create_table "product_page_fields", :force => true do |t|
    t.integer "page_id"
    t.decimal "price",   :precision => 10, :scale => 2
  end

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
