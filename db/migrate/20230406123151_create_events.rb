class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :user, null: false, foreign_key: true
      t.references :calendar, null: false, index: true, foreign_key: { on_delete: :cascade }
      t.datetime :remote_created_at
      t.datetime :remote_updated_at
      t.datetime :starts_at
      t.string :starts_at_timezone
      t.datetime :finishes_at
      t.string :finishes_at_timezone
      t.integer :self_sequence
      t.string :location
      t.string :description
      t.string :creator_email
      t.string :creator_id
      t.string :creator_display_name
      t.boolean :self_created
      t.string :etag
      t.string :event_type
      t.string :web_link
      t.string :i_cal_uid
      t.string :remote_id
      t.string :kind
      t.string :organizer_email
      t.string :organizer_id
      t.string :organizer_display_name
      t.boolean :self_organized
      t.text :reminders
      t.string :status
      t.string :summary
      t.string :transparency
      t.text :recurrence
      t.boolean :allow_new_time_proposals
      t.string :body_content_type
      t.string :body_content
      t.text :categories
      t.string :change_key
      t.boolean :has_attachments
      t.string :importance
      t.boolean :is_all_day
      t.boolean :is_cancelled
      t.boolean :is_draft
      t.boolean :is_online_meeting
      t.boolean :is_organizer
      t.boolean :end_time_unspecified
      t.boolean :is_reminder_on
      t.text :locations
      t.text :online_meeting
      t.string :online_meeting_provider
      t.string :online_meeting_url
      t.datetime :original_starts_at
      t.string :original_timezone_starts_at
      t.integer :reminder_minutes_before_start
      t.string :series_master_id
      t.string :response_status_text
      t.datetime :response_status_time
      t.boolean :response_requested
      t.string :show_as
      t.string :transaction_id
      t.string :visibility
      t.boolean :attendees_omitted
      t.text :extended_properties
      t.string :hangout_link
      t.text :conference_data
      t.text :gadget
      t.boolean :anyone_can_add_self
      t.boolean :guests_can_invite_others
      t.boolean :guests_can_modify
      t.boolean :guests_can_see_other_guests
      t.boolean :private_copy
      t.boolean :locked
      t.string :source_url
      t.string :source_title
      t.string :color_id
      t.text :working_location_properties
      t.text :attachments
      t.string :original_finishes_at_timezone

      t.timestamps
    end
  end
end
