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

ActiveRecord::Schema[7.0].define(version: 2023_03_14_140034) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "calendars", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "access_role"
    t.string "background_color"
    t.string "color_id"
    t.string "description"
    t.text "default_reminders"
    t.text "conference_properties"
    t.string "etag"
    t.string "foreground_color"
    t.string "remote_id"
    t.string "kind"
    t.boolean "selected"
    t.string "summary"
    t.string "summary_override"
    t.boolean "primary"
    t.boolean "deleted"
    t.boolean "hidden"
    t.string "time_zone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_calendars_on_user_id"
  end

  create_table "event_attendees", force: :cascade do |t|
    t.string "email"
    t.boolean "organizer"
    t.string "response_status"
    t.boolean "self"
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_attendees_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "calendar_id", null: false
    t.datetime "remote_created_at"
    t.datetime "remote_updated_at"
    t.datetime "starts_at"
    t.string "starts_at_timezone"
    t.datetime "finishes_at"
    t.string "finishes_at_timezone"
    t.datetime "original_starts_at"
    t.string "original_starts_at_time_zone"
    t.string "recurring_event_id"
    t.integer "sequence"
    t.string "location"
    t.string "description"
    t.string "creator_email"
    t.boolean "self_created"
    t.string "etag"
    t.string "event_type"
    t.string "html_link"
    t.string "i_cal_uid"
    t.string "remote_id"
    t.string "kind"
    t.string "organizer_email"
    t.boolean "self_organized"
    t.text "reminders"
    t.string "status"
    t.string "summary"
    t.string "transparency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id"], name: "index_events_on_calendar_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "google_token"
    t.string "azure_token"
    t.string "azure_refresh_token"
    t.datetime "azure_expire_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "calendars", "users"
  add_foreign_key "event_attendees", "events"
  add_foreign_key "events", "calendars"
  add_foreign_key "events", "users"
end
