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

ActiveRecord::Schema.define(version: 2019_06_06_060147) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "stations", force: :cascade do |t|
    t.string "identifier"
    t.string "name"
    t.datetime "last_updated"
    t.integer "total_bikes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "latest_used_bikes"
    t.integer "latest_free_bikes"
  end

  create_table "usage_logs", force: :cascade do |t|
    t.bigint "station_id"
    t.integer "used_bikes"
    t.integer "free_bikes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["station_id"], name: "index_usage_logs_on_station_id"
  end

  add_foreign_key "usage_logs", "stations"
end
