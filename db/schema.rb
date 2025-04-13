# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_04_13_194048) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "company_contracts", force: :cascade do |t|
    t.integer "contract_id", null: false
    t.string "company_name"
    t.string "registration_no"
    t.string "representative"
    t.text "service_description"
    t.decimal "price"
    t.string "duration"
    t.string "company_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_company_contracts_on_contract_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "registered_by"
    t.string "status"
    t.datetime "signed_at"
    t.datetime "registration_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_contracts_on_user_id"
  end

  create_table "course_content_requests", force: :cascade do |t|
    t.integer "request_id", null: false
    t.string "course"
    t.string "category"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_course_content_requests_on_request_id"
  end

  create_table "individual_contracts", force: :cascade do |t|
    t.integer "contract_id", null: false
    t.text "service_description"
    t.decimal "price"
    t.string "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_individual_contracts_on_contract_id"
  end

  create_table "requests", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "request_type"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "responses", force: :cascade do |t|
    t.integer "request_id", null: false
    t.integer "user_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_responses_on_request_id"
    t.index ["user_id"], name: "index_responses_on_user_id"
  end

  create_table "technical_requests", force: :cascade do |t|
    t.integer "request_id", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_technical_requests_on_request_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.string "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "company_contracts", "contracts"
  add_foreign_key "contracts", "users"
  add_foreign_key "course_content_requests", "requests"
  add_foreign_key "individual_contracts", "contracts"
  add_foreign_key "requests", "users"
  add_foreign_key "responses", "requests"
  add_foreign_key "responses", "users"
  add_foreign_key "technical_requests", "requests"
end
