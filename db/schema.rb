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

ActiveRecord::Schema[7.0].define(version: 2023_04_06_181204) do
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
    t.text "notification_settings"
    t.string "location"
    t.boolean "can_edit"
    t.boolean "can_share"
    t.boolean "can_view_private_items"
    t.string "change_key"
    t.string "allowed_online_meeting_providers"
    t.string "web_link"
    t.string "default_online_meeting_provider"
    t.boolean "is_tallying_responses"
    t.boolean "is_default_calendar"
    t.boolean "is_removable"
    t.boolean "should_sync", default: false
    t.string "owner_name"
    t.string "owner_email"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_calendars_on_user_id"
  end

  create_table "event_attendees", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "remote_id"
    t.string "email"
    t.boolean "organizer"
    t.string "response_status"
    t.boolean "is_self"
    t.string "comment"
    t.boolean "resource"
    t.boolean "optional"
    t.integer "additional_guests"
    t.string "display_name"
    t.string "type"
    t.datetime "response_status_time"
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
    t.integer "self_sequence"
    t.string "location"
    t.string "description"
    t.string "creator_email"
    t.string "creator_id"
    t.string "creator_display_name"
    t.boolean "self_created"
    t.string "etag"
    t.string "event_type"
    t.string "web_link"
    t.string "i_cal_uid"
    t.string "remote_id"
    t.string "kind"
    t.string "organizer_email"
    t.string "organizer_id"
    t.string "organizer_display_name"
    t.boolean "self_organized"
    t.text "reminders"
    t.string "status"
    t.string "summary"
    t.string "transparency"
    t.text "recurrence"
    t.boolean "allow_new_time_proposals"
    t.string "body_content_type"
    t.string "body_content"
    t.text "categories"
    t.string "change_key"
    t.boolean "has_attachments"
    t.string "importance"
    t.boolean "is_all_day"
    t.boolean "is_cancelled"
    t.boolean "is_draft"
    t.boolean "is_online_meeting"
    t.boolean "is_organizer"
    t.boolean "end_time_unspecified"
    t.boolean "is_reminder_on"
    t.text "locations"
    t.text "online_meeting"
    t.string "online_meeting_provider"
    t.string "online_meeting_url"
    t.datetime "original_starts_at"
    t.string "original_timezone_starts_at"
    t.integer "reminder_minutes_before_start"
    t.string "series_master_id"
    t.string "response_status_text"
    t.datetime "response_status_time"
    t.boolean "response_requested"
    t.string "show_as"
    t.string "transaction_id"
    t.string "visibility"
    t.boolean "attendees_omitted"
    t.text "extended_properties"
    t.string "hangout_link"
    t.text "conference_data"
    t.text "gadget"
    t.boolean "anyone_can_add_self"
    t.boolean "guests_can_invite_others"
    t.boolean "guests_can_modify"
    t.boolean "guests_can_see_other_guests"
    t.boolean "private_copy"
    t.boolean "locked"
    t.string "source_url"
    t.string "source_title"
    t.string "color_id"
    t.text "working_location_properties"
    t.text "attachments"
    t.string "original_finishes_at_timezone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id"], name: "index_events_on_calendar_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "external_events", force: :cascade do |t|
    t.bigint "calendar_id", null: false
    t.bigint "event_id", null: false
    t.string "external_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id"], name: "index_external_events_on_calendar_id"
    t.index ["event_id"], name: "index_external_events_on_event_id"
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
    t.string "google_refresh_token"
    t.datetime "google_expire_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "calendars", "users"
  add_foreign_key "event_attendees", "events", on_delete: :cascade
  add_foreign_key "events", "calendars", on_delete: :cascade
  add_foreign_key "events", "users"
  add_foreign_key "external_events", "calendars", on_delete: :cascade
  add_foreign_key "external_events", "events", on_delete: :cascade
end
