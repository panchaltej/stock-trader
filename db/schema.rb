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

ActiveRecord::Schema[8.0].define(version: 2024_11_12_061430) do
  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "symbol", null: false
    t.string "type", null: false
    t.decimal "filled_at_price", precision: 11, scale: 4
    t.bigint "quantity", null: false
    t.string "status"
    t.datetime "order_place_at"
    t.datetime "expired_at"
    t.datetime "filled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["symbol"], name: "index_orders_on_symbol"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "pending_orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "symbol", null: false
    t.string "type", null: false
    t.decimal "price", precision: 11, scale: 4, null: false
    t.bigint "quantity"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["symbol"], name: "index_pending_orders_on_symbol"
    t.index ["user_id"], name: "index_pending_orders_on_user_id"
  end
end
