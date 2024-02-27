# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_01_16_103357) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agents", force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.string "grade"
    t.string "identifier"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["identifier"], name: "index_agents_on_identifier", unique: true
  end

  create_table "civil_act_payments", force: :cascade do |t|
    t.string "transaction_id", limit: 100, null: false
    t.string "payment_trnx_ref"
    t.string "partner_code", limit: 50
    t.string "msisdn", limit: 25, null: false
    t.float "amount", default: 0.0, null: false
    t.string "currency", limit: 10, default: "GNF"
    t.string "description"
    t.text "request_body"
    t.text "response_data"
    t.integer "status", default: 0
    t.string "response_code", limit: 100
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "wallet", limit: 25
    t.float "transaction_fees", default: 0.0, null: false
    t.bigint "operation_type_id"
    t.index ["operation_type_id"], name: "index_civil_act_payments_on_operation_type_id"
    t.index ["payment_trnx_ref"], name: "index_civil_act_payments_on_payment_trnx_ref", unique: true
    t.index ["transaction_id"], name: "index_civil_act_payments_on_transaction_id", unique: true
  end

  create_table "cni_payments", force: :cascade do |t|
    t.string "transaction_id", limit: 100, null: false
    t.string "payment_trnx_ref"
    t.string "partner_code", limit: 50
    t.string "msisdn", limit: 25, null: false
    t.float "amount", default: 0.0, null: false
    t.string "currency", limit: 10, default: "GNF"
    t.string "description"
    t.text "request_body"
    t.text "response_data"
    t.integer "status", default: 0
    t.string "response_code", limit: 100
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "wallet", limit: 25
    t.float "transaction_fees", default: 0.0, null: false
    t.bigint "operation_type_id"
    t.index ["operation_type_id"], name: "index_cni_payments_on_operation_type_id"
    t.index ["payment_trnx_ref"], name: "index_cni_payments_on_payment_trnx_ref", unique: true
    t.index ["transaction_id"], name: "index_cni_payments_on_transaction_id", unique: true
  end

  create_table "contravention_groups", force: :cascade do |t|
    t.string "code", limit: 120, null: false
    t.string "label"
    t.float "amount", default: 0.0
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_contravention_groups_on_code", unique: true
  end

  create_table "contravention_notebooks", force: :cascade do |t|
    t.string "number", limit: 120, null: false
    t.string "label"
    t.integer "sheets", default: 1
    t.bigint "contravention_group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contravention_group_id"], name: "index_contravention_notebooks_on_contravention_group_id"
    t.index ["number"], name: "index_contravention_notebooks_on_number", unique: true
  end

  create_table "contravention_types", force: :cascade do |t|
    t.string "code", limit: 120, null: false
    t.string "label"
    t.bigint "contravention_group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_contravention_types_on_code", unique: true
    t.index ["contravention_group_id"], name: "index_contravention_types_on_contravention_group_id"
  end

  create_table "operation_types", force: :cascade do |t|
    t.string "code", limit: 120, null: false
    t.string "label"
    t.string "family", limit: 120
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "platforms", force: :cascade do |t|
    t.string "name"
    t.string "api_key"
    t.text "api_secret"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "traffic_ticket_payments", force: :cascade do |t|
    t.string "transaction_id", limit: 100, null: false
    t.string "ticket_number", limit: 120, null: false
    t.string "payment_trnx_ref"
    t.string "partner_code", limit: 50
    t.string "msisdn", limit: 25, null: false
    t.float "amount", default: 0.0, null: false
    t.float "transaction_fees", default: 0.0, null: false
    t.string "currency", limit: 10, default: "GNF"
    t.string "description"
    t.text "request_body"
    t.text "response_data"
    t.integer "status", default: 0
    t.string "response_code", limit: 100
    t.string "wallet", limit: 25
    t.bigint "contravention_type_id", null: false
    t.bigint "contravention_notebook_id", null: false
    t.bigint "agent_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "operation_type_id"
    t.index ["agent_id"], name: "index_traffic_ticket_payments_on_agent_id"
    t.index ["contravention_notebook_id"], name: "index_traffic_ticket_payments_on_contravention_notebook_id"
    t.index ["contravention_type_id"], name: "index_traffic_ticket_payments_on_contravention_type_id"
    t.index ["operation_type_id"], name: "index_traffic_ticket_payments_on_operation_type_id"
    t.index ["payment_trnx_ref"], name: "index_traffic_ticket_payments_on_payment_trnx_ref", unique: true
    t.index ["ticket_number"], name: "index_traffic_ticket_payments_on_ticket_number", unique: true
    t.index ["transaction_id"], name: "index_traffic_ticket_payments_on_transaction_id", unique: true
  end

  add_foreign_key "civil_act_payments", "operation_types"
  add_foreign_key "cni_payments", "operation_types"
  add_foreign_key "contravention_notebooks", "contravention_groups"
  add_foreign_key "contravention_types", "contravention_groups"
  add_foreign_key "traffic_ticket_payments", "agents"
  add_foreign_key "traffic_ticket_payments", "contravention_notebooks"
  add_foreign_key "traffic_ticket_payments", "contravention_types"
  add_foreign_key "traffic_ticket_payments", "operation_types"
end
