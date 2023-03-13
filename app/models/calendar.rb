class Calendar < ApplicationRecord
  include ActiveModel::Serializers::JSON

  serialize :conference_properties, JSON
  serialize :default_reminders, JSON

  belongs_to :user
  has_many :events
end
