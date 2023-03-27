class Event < ApplicationRecord
serialize :reminders, JSON
serialize :recurrence, JSON
serialize :attachments, JSON
serialize :conference_data, JSON
serialize :extended_properties, JSON
serialize :working_location_properties, JSON
serialize :locations, JSON
serialize :online_meeting, JSON
serialize :categories, JSON
serialize :gadget, JSON

has_many :event_attendees, dependent: :destroy
  belongs_to :user
  belongs_to :calendar
end
