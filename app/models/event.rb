class Event < ApplicationRecord
  include ActiveModel::Serializers::JSON

  serialize :reminders, JSON
  serialize :recurrence, JSON
  serialize :attachments, JSON
  serialize :conference_data, JSON
  serialize :extended_properties, JSON
  serialize :working_location_properties, JSON
  serialize :gadget, JSON
  serialize :locations, JSON
  serialize :online_meeting, JSON
  serialize :categories, JSON

  has_many :event_attendees, dependent: :destroy

  belongs_to :user
  belongs_to :calendar
end
