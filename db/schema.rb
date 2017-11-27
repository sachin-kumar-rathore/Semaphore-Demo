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

ActiveRecord::Schema.define(version: 20171124101223) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "business_units", force: :cascade do |t|
    t.string "name"
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_business_units_on_organization_id"
  end

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
    t.string "utility_provider_1"
    t.text "notes"
    t.string "business_unit"
    t.integer "company_establishment_year"
    t.integer "years_business_located"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.string "title"
    t.string "phone_number_1"
    t.string "phone_number_2"
    t.string "cell_phone"
    t.string "fax"
    t.string "region"
    t.string "utility_provider_2"
    t.string "facility_type"
    t.string "acreage"
    t.string "building_size"
    t.string "number_of"
    t.string "average_age_of_buildings"
    t.boolean "room_for_expansion"
    t.string "owned_or_leased"
    t.date "lease_expiration_date"
    t.text "facility_notes"
    t.text "primary_products_and_services"
    t.integer "full_time_employees"
    t.integer "part_time_employees"
    t.integer "leased_employees"
    t.integer "total_employees"
    t.integer "number_of_jobs_added_or_lost_in_past_3_years"
    t.integer "number_of_shifts_per_day"
    t.integer "number_of_days_per_week"
    t.string "average_annual_salary"
    t.date "date_of_total"
    t.text "employment_notes"
    t.boolean "business_union_represented"
    t.index ["organization_id"], name: "index_companies_on_organization_id"
  end

  create_table "company_activity_types", force: :cascade do |t|
    t.string "name"
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_company_activity_types_on_organization_id"
  end

  create_table "company_contacts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.bigint "contact_id"
    t.index ["company_id"], name: "index_company_contacts_on_company_id"
    t.index ["contact_id"], name: "index_company_contacts_on_contact_id"
  end

  create_table "competitions", force: :cascade do |t|
    t.string "name"
    t.string "status"
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_competitions_on_organization_id"
  end

  create_table "considered_locations", force: :cascade do |t|
    t.string "status"
    t.string "location"
    t.string "city"
    t.string "country"
    t.string "city_abbreviation"
    t.string "country_abbreviation"
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_considered_locations_on_organization_id"
  end

  create_table "contact_categories", force: :cascade do |t|
    t.string "name"
    t.string "status"
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_contact_categories_on_organization_id"
  end

  create_table "contact_considered_locations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "contact_id"
    t.bigint "considered_location_id"
    t.index ["considered_location_id"], name: "index_contact_considered_locations_on_considered_location_id"
    t.index ["contact_id"], name: "index_contact_considered_locations_on_contact_id"
  end

  create_table "contact_method_types", force: :cascade do |t|
    t.string "name"
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_contact_method_types_on_organization_id"
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

  create_table "contacts_emails", id: false, force: :cascade do |t|
    t.bigint "contact_id", null: false
    t.bigint "email_id", null: false
    t.index ["contact_id", "email_id"], name: "index_contacts_emails_on_contact_id_and_email_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "name"
    t.string "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.bigint "project_id"
    t.bigint "user_id"
    t.index ["organization_id"], name: "index_documents_on_organization_id"
    t.index ["project_id"], name: "index_documents_on_project_id"
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "elimination_reasons", force: :cascade do |t|
    t.string "name"
    t.string "status"
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_elimination_reasons_on_organization_id"
  end

  create_table "emails", force: :cascade do |t|
    t.integer "organization_id"
    t.integer "project_id"
    t.string "sent_by"
    t.string "sent_to"
    t.string "subject"
    t.string "messageID"
    t.text "body"
    t.datetime "email_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cc"
  end

  create_table "industry_types", force: :cascade do |t|
    t.string "name"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.index ["organization_id"], name: "index_industry_types_on_organization_id"
  end

  create_table "notes", force: :cascade do |t|
    t.date "date"
    t.text "description"
    t.string "subject"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_notes_on_project_id"
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

  create_table "project_sites", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_id"
    t.bigint "site_id"
    t.index ["project_id"], name: "index_project_sites_on_project_id"
    t.index ["site_id"], name: "index_project_sites_on_site_id"
  end

  create_table "project_types", force: :cascade do |t|
    t.string "name"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.index ["organization_id"], name: "index_project_types_on_organization_id"
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

  create_table "provided_services", force: :cascade do |t|
    t.string "name"
    t.string "status"
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_provided_services_on_organization_id"
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

  create_table "sources", force: :cascade do |t|
    t.string "name"
    t.string "status"
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_sources_on_organization_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.text "description"
    t.date "start_date"
    t.date "end_date"
    t.string "priority"
    t.string "status"
    t.float "progress", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "assignee_id"
    t.bigint "project_id"
    t.index ["project_id"], name: "index_tasks_on_project_id"
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

  add_foreign_key "business_units", "organizations"
  add_foreign_key "companies", "organizations"
  add_foreign_key "company_activity_types", "organizations"
  add_foreign_key "company_contacts", "companies"
  add_foreign_key "company_contacts", "contacts"
  add_foreign_key "competitions", "organizations"
  add_foreign_key "considered_locations", "organizations"
  add_foreign_key "contact_categories", "organizations"
  add_foreign_key "contact_considered_locations", "considered_locations"
  add_foreign_key "contact_considered_locations", "contacts"
  add_foreign_key "contact_method_types", "organizations"
  add_foreign_key "documents", "organizations"
  add_foreign_key "documents", "projects"
  add_foreign_key "documents", "users"
  add_foreign_key "elimination_reasons", "organizations"
  add_foreign_key "industry_types", "organizations"
  add_foreign_key "notes", "projects"
  add_foreign_key "project_contacts", "contacts"
  add_foreign_key "project_contacts", "projects"
  add_foreign_key "project_sites", "projects"
  add_foreign_key "project_sites", "sites"
  add_foreign_key "project_types", "organizations"
  add_foreign_key "projects", "companies"
  add_foreign_key "projects", "organizations"
  add_foreign_key "provided_services", "organizations"
  add_foreign_key "sources", "organizations"
  add_foreign_key "tasks", "projects"
  add_foreign_key "users", "organizations"
end
