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

ActiveRecord::Schema.define(version: 2021_06_29_055019) do

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.integer "sequence", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string "name", null: false
    t.integer "sequence", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shop_memos", force: :cascade do |t|
    t.integer "shop_id", null: false
    t.string "title", null: false
    t.text "body", null: false
    t.index ["shop_id"], name: "index_shop_memos_on_shop_id"
  end

  create_table "shop_states", primary_key: ["shop_id", "state_id"], force: :cascade do |t|
    t.integer "shop_id", null: false
    t.integer "state_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_shop_states_on_shop_id"
    t.index ["state_id"], name: "index_shop_states_on_state_id"
  end

  create_table "shop_translations", force: :cascade do |t|
    t.integer "shop_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "desc"
    t.string "keyword"
    t.index ["locale"], name: "index_shop_translations_on_locale"
    t.index ["shop_id"], name: "index_shop_translations_on_shop_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name", null: false
    t.text "memo"
    t.integer "category_id"
    t.integer "status", limit: 1, default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.date "foo_date"
    t.date "bar_date"
    t.datetime "quz_datetime"
    t.text "data"
    t.index ["category_id"], name: "index_shops_on_category_id"
  end

  create_table "states", force: :cascade do |t|
    t.string "name", null: false
    t.integer "sequence", null: false
    t.integer "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_states_on_country_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.integer "role", limit: 2, null: false
    t.integer "sequence", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "shop_memos", "shops"
  add_foreign_key "shop_states", "shops"
  add_foreign_key "shop_states", "states"
  add_foreign_key "shops", "categories"
  add_foreign_key "states", "countries"
end
