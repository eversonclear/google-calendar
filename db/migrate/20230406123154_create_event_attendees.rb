class CreateEventAttendees < ActiveRecord::Migration[7.0]
  def change
    create_table :event_attendees do |t|
      t.references :event, null: false, foreign_key: true
      t.string :remote_id
      t.string :email
      t.boolean :organizer
      t.string :response_status
      t.boolean :is_self
      t.string :comment
      t.boolean :resource
      t.boolean :optional
      t.integer :additional_guests
      t.string :display_name
      t.string :type
      t.datetime :response_status_time

      t.timestamps
    end
  end
end
