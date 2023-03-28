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

  def self.mount_body_remote_event(event_params)
    if event_params[:starts_at].present?
      event_params[:start] = {
        date_time: event_params[:starts_at],
        time_zone: event_params[:starts_at_timezone] || 'UTC'
      }
    end

    if event_params[:finishes_at].present?
      event_params[:end] = {
        date_time: event_params[:finishes_at],
        time_zone: event_params[:finishes_at_timezone] || 'UTC'
      }
    end

    if event_params[:original_starts_at].present?
      event_params[:original_start_time] = {
        date_time: event_params[:original_starts_at],
        time_zone: event_params[:original_timezone_starts_at]
      }
    end

    if event_params[:source_url].present?
      event_params[:source] = {
        title: event_params[:source_title],
        url: event_params[:source_url]
      }
    end
    
    keys_deleted = [:starts_at, :starts_at_timezone, :original_starts_at, :original_timezone_starts_at, :finishes_at, :finishes_at_timezone]
    keys_deleted.each { |key| event_params.delete(key)}

    event_params
  end
end

