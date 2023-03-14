class Event < ApplicationRecord
  include ActiveModel::Serializers::JSON

  serialize :reminders, JSON

  has_many :event_attendees
  belongs_to :user
  belongs_to :calendar
end
