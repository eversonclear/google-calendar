class Event < ApplicationRecord
  include ActiveModel::Serializers::JSON

  serialize :reminders, JSON

  belongs_to :user
  belongs_to :calendar
end
