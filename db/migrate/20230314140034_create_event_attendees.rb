class CreateEventAttendees < ActiveRecord::Migration[7.0]
  def change
    create_table :event_attendees do |t|
      t.string :email
      t.boolean :organizer
      t.string :response_status
      t.boolean :self
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
