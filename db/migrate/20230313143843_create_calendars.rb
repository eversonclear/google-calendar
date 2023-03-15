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

      t.timestamps
    end
  end
end
