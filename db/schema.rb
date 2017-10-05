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

ActiveRecord::Schema.define(version: 20171005194251) do

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
    t.integer "company_id"
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.string "address_line_1"
    t.string "city"
    t.string "zip_code"
    t.string "country"
    t.string "business_unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
