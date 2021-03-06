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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140609144026) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                                                                                                                                                                                      :default => "",           :null => false
    t.string   "encrypted_password",                                                                                                                                                                                         :default => "",           :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                                                                                                                                                                              :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                                                                                                                                                                                                           :null => false
    t.datetime "updated_at",                                                                                                                                                                                                                           :null => false
    t.string   "user_name"
    t.string   "telephone"
    t.string   "organization"
    t.enum     "role",                   :limit => [:role_super, :role_admin, :role_dev, :role_fin, :role_plm, :role_sales, :role_material_controller, :role_service, :role_buyer, :role_oem, :role_supplier, :role_others], :default => :role_others
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true
  add_index "admin_users", ["user_name"], :name => "index_admin_users_on_user_name", :unique => true

  create_table "bom_parts", :force => true do |t|
    t.integer  "bom_id"
    t.integer  "part_number_id"
    t.integer  "amount",         :default => 1
    t.string   "location"
    t.string   "comments"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "boms", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "code"
    t.string   "version"
    t.string   "prepared_by"
    t.string   "approved_by"
    t.enum     "status",        :limit => [:status_in_progress, :status_pending_approval, :status_active, :status_transient, :status_outdated], :default => :status_in_progress
    t.datetime "created_at",                                                                                                                                                     :null => false
    t.datetime "updated_at",                                                                                                                                                     :null => false
    t.integer  "parent_bom_id"
  end

  create_table "change_histories", :force => true do |t|
    t.string   "updated_by"
    t.string   "notes"
    t.datetime "updated_at"
    t.integer  "trackable_obj_id"
    t.string   "trackable_obj_type"
  end

  create_table "company_profiles", :force => true do |t|
    t.string   "company_name"
    t.string   "company_addr"
    t.string   "postcode"
    t.string   "company_desc"
    t.string   "contact"
    t.string   "primary_phone"
    t.string   "secondary_phone"
    t.string   "distribution_list"
    t.string   "appendix"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "companyable_id"
    t.string   "companyable_type"
  end

  create_table "component_categories", :force => true do |t|
    t.string   "name"
    t.string   "comment"
    t.string   "code"
    t.string   "updated_by_email"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "ancestry"
    t.integer  "ancestry_depth",   :default => 0
  end

  add_index "component_categories", ["ancestry"], :name => "index_component_categories_on_ancestry"

  create_table "customers", :primary_key => "c_id", :force => true do |t|
    t.string   "name"
    t.enum     "status",     :limit => [:company_active, :company_outdated, :company_transient], :default => :company_active
    t.string   "comment"
    t.datetime "created_at",                                                                                                  :null => false
    t.datetime "updated_at",                                                                                                  :null => false
  end

  create_table "inventories", :force => true do |t|
    t.integer  "item_id"
    t.string   "item_type"
    t.integer  "location_id"
    t.string   "location_type"
    t.integer  "quantity_of_in_manufacturing",                               :default => 0
    t.integer  "quantity_of_surplus",                                        :default => 0
    t.decimal  "average_price",                :precision => 8, :scale => 2, :default => 1.0
    t.datetime "updated_at"
  end

  create_table "oems", :primary_key => "o_id", :force => true do |t|
    t.string   "name"
    t.enum     "status",     :limit => [:company_active, :company_outdated, :company_transient], :default => :company_active
    t.string   "comment"
    t.datetime "created_at",                                                                                                  :null => false
    t.datetime "updated_at",                                                                                                  :null => false
  end

  create_table "order_items", :force => true do |t|
    t.integer "part_number_id"
    t.integer "volume"
    t.decimal "price",             :precision => 8, :scale => 2
    t.string  "comment"
    t.integer "purchase_order_id"
  end

  create_table "part_numbers", :force => true do |t|
    t.string   "name"
    t.string   "code",                  :limit => 17
    t.string   "old_code"
    t.string   "vendor_code"
    t.enum     "status",                :limit => [:status_in_progress, :status_pending_approval, :status_active, :status_transient, :status_outdated],                               :default => :status_in_progress
    t.decimal  "latest_price",                                                                                                                          :precision => 8, :scale => 2
    t.string   "prepared_by"
    t.string   "approved_by"
    t.integer  "supplier_id",                                                                                                                                                                                          :null => false
    t.integer  "component_category_id",                                                                                                                                                                                :null => false
    t.datetime "created_at"
    t.integer  "preference"
    t.integer  "min_amount",                                                                                                                                                          :default => 1
    t.string   "description"
    t.string   "appendix"
    t.integer  "group_id"
  end

  create_table "production_orders", :force => true do |t|
    t.string   "order_id",                                                                                            :null => false
    t.enum     "production_type",               :limit => [:TRIAL_PRODUCTION, :MASSIVE_PRODUCTION, :TEST_PRODUCTION]
    t.enum     "manufacturing_process",         :limit => [:LEAD_FREE, :LEAD, :MIXTURE]
    t.enum     "rf_frequency",                  :limit => [:GSM_DUAL_BAND, :GSM_QUAD_BAND, :GSM_AND_TDSCDMA]
    t.integer  "sn_start_no"
    t.integer  "imei_start_no"
    t.integer  "volume"
    t.integer  "no_of_imei"
    t.string   "associated_bom"
    t.string   "associated_manufacturing_docs"
    t.string   "associated_sw_version"
    t.string   "associated_test_tool_set"
    t.text     "comments"
    t.string   "appendix"
    t.string   "ordered_by"
    t.datetime "ordered_at"
    t.integer  "bom_id",                                                                                              :null => false
    t.integer  "product_id"
    t.integer  "oem_id",                                                                                              :null => false
    t.datetime "created_at",                                                                                          :null => false
    t.datetime "updated_at",                                                                                          :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.string   "pcb_ver"
    t.string   "bom_appendix"
    t.string   "sw_appendix"
    t.string   "tool_appendix"
    t.string   "doc_appendix"
    t.string   "comment"
    t.string   "updated_by"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "purchase_orders", :force => true do |t|
    t.string  "name"
    t.string  "order_id",                 :limit => 18
    t.integer "supplier_id"
    t.integer "supply_agent_id"
    t.integer "oem_id"
    t.enum    "delivery_vendor",          :limit => [:"---\\n- 自提\\n- 1\\n", :"---\\n- 亲自送货\\n- 2\\n", :"---\\n- 众邦\\n- 3\\n", :"---\\n- 圆通\\n- 4\\n", :"---\\n- 顺丰\\n- 5\\n", :"---\\n- 其他\\n- 6\\n"]
    t.string  "delivery_tracking_number"
    t.string  "prepared_by"
    t.string  "approved_by"
    t.enum    "status",                   :limit => [:status_in_progress, :status_pending_confirmation, :status_submitted, :status_in_delivery, :status_received, :status_closed],                      :default => :status_in_progress
    t.enum    "supply_type",              :limit => [:supplier_itself, :supplier_agent],                                                                                                                :default => :supplier_itself
    t.string  "src_addr"
    t.string  "supplier_dist_list"
    t.string  "dest_addr"
    t.string  "oem_dist_list"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "suppliers", :primary_key => "s_id", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                                                                                                  :null => false
    t.datetime "updated_at",                                                                                                  :null => false
    t.enum     "status",     :limit => [:company_active, :company_outdated, :company_transient], :default => :company_active
    t.string   "comment"
  end

  create_table "supply_agents", :primary_key => "sa_id", :force => true do |t|
    t.string   "name"
    t.enum     "status",     :limit => [:company_active, :company_outdated, :company_transient], :default => :company_active
    t.string   "comment"
    t.datetime "created_at",                                                                                                  :null => false
    t.datetime "updated_at",                                                                                                  :null => false
  end

  create_table "transaction_histories", :force => true do |t|
    t.integer  "item_id"
    t.string   "item_type"
    t.integer  "location_id"
    t.string   "location_type"
    t.integer  "quantity",                                                                                                                       :default => 0
    t.decimal  "average_price",                                                                                    :precision => 8, :scale => 2, :default => 1.0
    t.string   "created_by"
    t.enum     "transaction_type",   :limit => [:buy_in, :in_manufacturing, :used, :manual_adjustment, :obsolete]
    t.datetime "created_at"
    t.string   "reference_obj_type"
    t.integer  "reference_obj_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "companyable_id"
    t.string   "companyable_type"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
