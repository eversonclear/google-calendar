class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :user, null: false, foreign_key: true
      t.references :calendar, null: false, foreign_key: true
      t.datetime :remote_created_at
      t.datetime :remote_updated_at
      t.datetime :starts_at
      t.string :starts_at_timezone
      t.datetime :finishes_at
      t.string :finishes_at_timezone
      t.integer :sequence
      t.string :location
      t.string :description
      t.string :creator_email
      t.boolean :self_created
      t.string :etag
      t.string :event_type
      t.string :html_link
      t.string :i_cal_uid
      t.string :remote_id
      t.string :kind
      t.string :organizer_email
      t.boolean :self_organized
      t.text :reminders
      t.string :status
      t.string :summary
      t.string :transparency
      t.string :recurrences
      t.timestamps
    end
  end
end
