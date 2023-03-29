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

  accepts_nested_attributes_for :event_attendees

  GOOGLE_EVENTS_FIELDS = [
    :anyone_can_add_self, :attachments, :attendees, :color_id, 
    :conference_data, :description, :finishes_at, :finishes_at_timezone, :starts_at, :starts_at_timezone, 
    :extended_properties, :gadget, :location, :original_start_at, :original_timezone_start_at, :recurrence, :reminders, 
    :sequence, :source_title, :source_url, :status, :summary, :transparency, :visibility
  ]

  GOOGLE_EVENTS_ATTENDEES_FIELDS = [
    :email, :organizer, :response_status, :self,
    :comment, :resource, :optional, :additional_guest, :display_name
  ]

  def self.mount_body_remote_event(event)
    event_google_params = event.slice(*GOOGLE_EVENTS_FIELDS)
    event_attendees_google_params = event.event_attendees.pluck(*GOOGLE_EVENTS_ATTENDEES_FIELDS)

    event_google_params[:start] = {
      date_time: event_google_params[:starts_at],
      time_zone: event_google_params[:starts_at_timezone] || 'UTC'
    }

    event_google_params[:end] = {
      date_time: event_google_params[:finishes_at],
      time_zone: event_google_params[:finishes_at_timezone] || 'UTC'
    }

    event_google_params[:original_start_time] = {
      date_time: event_google_params[:original_starts_at],
      time_zone: event_google_params[:original_timezone_starts_at] || 'UTC'
    }

    event_google_params[:source] = {
      title: event_google_params[:source_title],
      url: event_google_params[:source_url]
    }

    event_params[:attendees] = event_attendees_google_params.map do |event_attendee|
      {
        email: event_attendee[:email],
        organizer: event_attendee[:organizer],
        response_status: event_attendee[:response_status],
        self: event_attendee[:is_self],
        comment: event_attendee[:comment],
        resource: event_attendee[:resource],
        optional: event_attendee[:optional],
        additional_guests: event_attendee[:additional_guests],
        display_name: event_attendee[:display_name]
      }
    end
    
    keys_deleted = [:starts_at, :starts_at_timezone, :original_starts_at, :original_timezone_starts_at, :finishes_at, :finishes_at_timezone]
    keys_deleted.each { |key| event_params.delete(key)}

    event_params
  end
end

