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

ActiveRecord::Schema.define(version: 20180310041448) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "activities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_activity_type_id"
    t.bigint "company_id"
    t.bigint "incentive_id"
    t.bigint "contact_method_type_id"
    t.string "name"
    t.string "activity_number"
    t.date "contact_date"
    t.integer "primary_contact_id"
    t.integer "assigned_user"
    t.text "description"
    t.date "follow_up_date"
    t.bigint "organization_id"
    t.boolean "converted", default: false
    t.index ["company_activity_type_id"], name: "index_activities_on_company_activity_type_id"
    t.index ["company_id"], name: "index_activities_on_company_id"
    t.index ["contact_method_type_id"], name: "index_activities_on_contact_method_type_id"
    t.index ["incentive_id"], name: "index_activities_on_incentive_id"
    t.index ["organization_id"], name: "index_activities_on_organization_id"
  end

  create_table "admins", force: :cascade do |t|
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
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

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
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "country"
    t.string "website"
    t.string "email"
    t.boolean "member_investor"
    t.text "notes"
    t.integer "company_establishment_year"
    t.integer "years_business_located"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.string "phone_number_1"
    t.string "phone_number_2"
    t.string "cell_phone"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "fax"
    t.string "region"
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
    t.string "peak_season"
    t.text "union_notes"
    t.bigint "industry_type_id"
    t.bigint "project_type_id"
    t.string "naics_code_1"
    t.string "naics_code_2"
    t.string "naics_code_3"
    t.string "naics_code_4"
    t.string "naics_code_5"
    t.index ["industry_type_id"], name: "index_companies_on_industry_type_id"
    t.index ["organization_id"], name: "index_companies_on_organization_id"
    t.index ["project_type_id"], name: "index_companies_on_project_type_id"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "address_line_2"
    t.string "phone_number_2"
    t.string "cell_phone"
    t.text "notes"
    t.bigint "contact_category_id"
    t.bigint "business_unit_id"
    t.string "organization_name"
    t.string "linkedin_url"
    t.index ["business_unit_id"], name: "index_contacts_on_business_unit_id"
    t.index ["contact_category_id"], name: "index_contacts_on_contact_category_id"
  end

  create_table "contacts_emails", id: false, force: :cascade do |t|
    t.bigint "contact_id", null: false
    t.bigint "email_id", null: false
    t.index ["contact_id", "email_id"], name: "index_contacts_emails_on_contact_id_and_email_id"
  end

  create_table "custom_exports", force: :cascade do |t|
    t.string "name"
    t.string "filters", default: [], array: true
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_custom_exports_on_user_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "name"
    t.string "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.bigint "user_id"
    t.string "documentable_type"
    t.bigint "documentable_id"
    t.index ["documentable_type", "documentable_id"], name: "index_documents_on_documentable_type_and_documentable_id"
    t.index ["organization_id"], name: "index_documents_on_organization_id"
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
    t.string "sent_by"
    t.string "sent_to"
    t.string "subject"
    t.string "messageID"
    t.text "body"
    t.datetime "email_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cc"
    t.string "mailable_type"
    t.bigint "mailable_id"
    t.index ["mailable_type", "mailable_id"], name: "index_emails_on_mailable_type_and_mailable_id"
  end

  create_table "incentives", force: :cascade do |t|
    t.string "name"
    t.string "status"
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_incentives_on_organization_id"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "notable_type"
    t.bigint "notable_id"
    t.index ["notable_type", "notable_id"], name: "index_notes_on_notable_type_and_notable_id"
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
    t.string "logo"
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
    t.integer "primary_contact_id"
    t.text "description"
    t.date "active_date"
    t.date "successful_completion_date"
    t.string "business_type"
    t.string "square_feet_requested"
    t.text "square_footage_note"
    t.string "acres_requested"
    t.text "acreage_note"
    t.integer "new_jobs", default: 0
    t.text "new_jobs_notes"
    t.decimal "wages", default: "0.0"
    t.text "wages_notes"
    t.decimal "net_new_investment", default: "0.0"
    t.text "net_new_investment_notes"
    t.date "public_release_date"
    t.boolean "public_release"
    t.boolean "site_selector"
    t.boolean "utilize_sites"
    t.boolean "speculative_building"
    t.string "where_located"
    t.string "project_number"
    t.integer "retained_jobs", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.bigint "organization_id"
    t.bigint "project_type_id"
    t.bigint "industry_type_id"
    t.bigint "business_unit_id"
    t.bigint "considered_location_id"
    t.bigint "competition_id"
    t.bigint "incentive_id"
    t.bigint "source_id"
    t.bigint "elimination_reason_id"
    t.integer "project_manager_id"
    t.integer "other_square_ft_requested", default: 0
    t.index ["business_unit_id"], name: "index_projects_on_business_unit_id"
    t.index ["company_id"], name: "index_projects_on_company_id"
    t.index ["competition_id"], name: "index_projects_on_competition_id"
    t.index ["considered_location_id"], name: "index_projects_on_considered_location_id"
    t.index ["elimination_reason_id"], name: "index_projects_on_elimination_reason_id"
    t.index ["incentive_id"], name: "index_projects_on_incentive_id"
    t.index ["industry_type_id"], name: "index_projects_on_industry_type_id"
    t.index ["organization_id"], name: "index_projects_on_organization_id"
    t.index ["project_type_id"], name: "index_projects_on_project_type_id"
    t.index ["source_id"], name: "index_projects_on_source_id"
  end

  create_table "security_roles", force: :cascade do |t|
    t.string "name"
    t.hstore "project_permissions", default: {}
    t.hstore "user_permissions", default: {}
    t.hstore "configuration_permissions", default: {}
    t.hstore "site_permissions", default: {}
    t.hstore "contact_permissions", default: {}
    t.hstore "company_permissions", default: {}
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_security_roles_on_organization_id"
  end

  create_table "service_provideds", force: :cascade do |t|
    t.string "name"
    t.string "status"
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_service_provideds_on_organization_id"
  end

  create_table "site_visits", force: :cascade do |t|
    t.integer "project_id"
    t.date "visit_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sites", force: :cascade do |t|
    t.integer "organization_id"
    t.integer "contact_id"
    t.string "site_number"
    t.string "name"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "business_unit_id"
    t.string "special_district"
    t.index ["business_unit_id"], name: "index_sites_on_business_unit_id"
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
    t.integer "assignee_id"
    t.string "name"
    t.text "description"
    t.date "start_date"
    t.date "end_date"
    t.string "priority"
    t.string "status"
    t.float "progress", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "taskable_type"
    t.bigint "taskable_id"
    t.index ["taskable_type", "taskable_id"], name: "index_tasks_on_taskable_type_and_taskable_id"
  end

  create_table "transactional_emails", force: :cascade do |t|
    t.text "subject"
    t.text "body"
    t.integer "type_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "security_role_id"
    t.index ["security_role_id"], name: "index_user_roles_on_security_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
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
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.boolean "active"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "activities", "companies"
  add_foreign_key "activities", "company_activity_types"
  add_foreign_key "activities", "contact_method_types"
  add_foreign_key "activities", "incentives"
  add_foreign_key "activities", "organizations"
  add_foreign_key "business_units", "organizations"
  add_foreign_key "companies", "industry_types"
  add_foreign_key "companies", "organizations"
  add_foreign_key "companies", "project_types"
  add_foreign_key "company_activity_types", "organizations"
  add_foreign_key "company_contacts", "companies"
  add_foreign_key "company_contacts", "contacts"
  add_foreign_key "competitions", "organizations"
  add_foreign_key "considered_locations", "organizations"
  add_foreign_key "contact_categories", "organizations"
  add_foreign_key "contact_considered_locations", "considered_locations"
  add_foreign_key "contact_considered_locations", "contacts"
  add_foreign_key "contact_method_types", "organizations"
  add_foreign_key "contacts", "business_units"
  add_foreign_key "contacts", "contact_categories"
  add_foreign_key "custom_exports", "users"
  add_foreign_key "documents", "organizations"
  add_foreign_key "documents", "users"
  add_foreign_key "elimination_reasons", "organizations"
  add_foreign_key "incentives", "organizations"
  add_foreign_key "industry_types", "organizations"
  add_foreign_key "project_contacts", "contacts"
  add_foreign_key "project_contacts", "projects"
  add_foreign_key "project_sites", "projects"
  add_foreign_key "project_sites", "sites"
  add_foreign_key "project_types", "organizations"
  add_foreign_key "projects", "business_units"
  add_foreign_key "projects", "companies"
  add_foreign_key "projects", "competitions"
  add_foreign_key "projects", "considered_locations"
  add_foreign_key "projects", "elimination_reasons"
  add_foreign_key "projects", "incentives"
  add_foreign_key "projects", "industry_types"
  add_foreign_key "projects", "organizations"
  add_foreign_key "projects", "project_types"
  add_foreign_key "projects", "sources"
  add_foreign_key "security_roles", "organizations"
  add_foreign_key "service_provideds", "organizations"
  add_foreign_key "sites", "business_units"
  add_foreign_key "sources", "organizations"
  add_foreign_key "user_roles", "security_roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "users", "organizations"
end
