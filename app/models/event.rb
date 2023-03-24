class Event < ApplicationRecord
  include ActiveModel::Serializers::JSON

  serialize :reminders, JSON
  serialize :recurrences, JSON
  serialize :attachments, JSON
  serialize :conference_data, JSON
  serialize :extended_properties, JSON
  serialize :working_location_properties, JSON
  serialize :gadget, JSON

  has_many :event_attendees

  belongs_to :user
  belongs_to :calendar
end
