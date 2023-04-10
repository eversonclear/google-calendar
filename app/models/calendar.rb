class Calendar < ApplicationRecord
  include ActiveModel::Serializers::JSON

  serialize :conference_properties, JSON
  serialize :default_reminders, JSON
  serialize :notification_settings, JSON

  has_many :events
  belongs_to :user
end
