class CreateCalendars < ActiveRecord::Migration[7.0]
  def change
    create_table :calendars do |t|
      t.references :user, null: false, foreign_key: true
      t.string :access_role
      t.string :background_color
      t.string :color_id
      t.string :description
      t.text :default_reminders
      t.text :conference_properties
      t.string :etag
      t.string :foreground_color
      t.string :remote_id
      t.string :kind
      t.boolean :selected
      t.string :summary
      t.string :summary_override
      t.boolean :primary
      t.boolean :deleted
      t.boolean :hidden
      t.string :time_zone
      t.text :notification_settings
      t.string :location
      t.boolean :can_edit
      t.boolean :can_share
      t.boolean :can_view_private_items
      t.string :change_key
      t.string :allowed_online_meeting_providers
      t.string :web_link
      t.string :default_online_meeting_provider
      t.boolean :is_tallying_responses
      t.boolean :is_default_calendar
      t.boolean :is_removable
      t.string :owner_name
      t.string :owner_email
      t.string :status

      t.timestamps
    end
  end
end
