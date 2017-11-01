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

ActiveRecord::Schema.define(version: 201710201937989) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.integer "owner_id"
    t.integer "subscription_id"
    t.string "name"
    t.integer "company_number"
    t.string "business_sector"
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "country"
    t.string "website"
    t.string "email"
    t.boolean "member_investor"
    t.string "utility_provider"
    t.text "notes"
    t.string "business_unit"
    t.integer "company_establishment_year"
    t.integer "years_business_located"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.integer "organization_id"
    t.string "name"
    t.string "email"
    t.string "phone_number_1"
    t.string "address_line_1"
    t.string "city_state_zip"
    t.string "fax"
    t.string "website"
    t.string "business_unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.string "title"
    t.string "address_line_2"
    t.string "phone_number_2"
    t.string "cell_phone"
    t.text "notes"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "primary_contact_first_name"
    t.string "primary_contact_last_name"
    t.string "primary_contact_phone"
    t.string "primary_contact_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_contacts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_id"
    t.bigint "contact_id"
    t.index ["contact_id"], name: "index_project_contacts_on_contact_id"
    t.index ["project_id"], name: "index_project_contacts_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.string "status"
    t.string "project_type"
    t.string "source"
    t.integer "primary_contact_id"
    t.string "industry_type"
    t.string "business_unit"
    t.text "description"
    t.date "active_date"
    t.date "successful_completion_date"
    t.string "business_type"
    t.string "square_feet_requested"
    t.text "square_footage_note"
    t.string "acres_requested"
    t.text "acreage_note"
    t.string "new_jobs"
    t.text "new_jobs_notes"
    t.decimal "wages"
    t.text "wages_notes"
    t.decimal "net_new_investment"
    t.text "net_new_investment_notes"
    t.date "public_release_date"
    t.boolean "public_release"
    t.boolean "site_selector"
    t.boolean "utilize_sites"
    t.boolean "speculative_building"
    t.string "elimination_reason"
    t.string "located"
    t.string "unique_id"
    t.string "retained_jobs"
    t.date "site_visit_1"
    t.date "site_visit_2"
    t.date "site_visit_3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.bigint "organization_id"
    t.index ["company_id"], name: "index_projects_on_company_id"
    t.index ["organization_id"], name: "index_projects_on_organization_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "sites", force: :cascade do |t|
    t.integer "organization_id"
    t.integer "contact_id"
    t.string "property_number"
    t.string "property_name"
    t.string "property_type"
    t.string "address_line"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "country"
    t.float "available_acreage"
    t.float "available_square_feet"
    t.float "total_acreage"
    t.float "total_square_feet"
    t.float "latitude"
    t.float "longitude"
    t.string "business_unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_sites_on_deleted_at"
  end

  create_table "tasks", force: :cascade do |t|
    t.integer "user_id"
    t.integer "project_id"
    t.integer "assigned_to"
    t.string "name"
    t.text "description"
    t.date "start_date"
    t.date "end_date"
    t.string "priority"
    t.string "status"
    t.float "progress", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "project_contacts", "contacts"
  add_foreign_key "project_contacts", "projects"
  add_foreign_key "projects", "companies"
  add_foreign_key "projects", "organizations"
  add_foreign_key "users", "organizations"
end
