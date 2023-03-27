class Calendar < ApplicationRecord
  include ActiveModel::Serializers::JSON

  serialize :conference_properties, JSON
  serialize :default_reminders, JSON

  has_many :events, dependent: :destroy
  belongs_to :user
end
