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

  before_destroy :sync_delete
  after_commit :sync_create, on: :create
  after_commit :sync_update, on: :update

  has_many :event_attendees
  has_many :external_events

  accepts_nested_attributes_for :event_attendees
  belongs_to :user
  belongs_to :calendar

  GOOGLE_EVENTS_FIELDS = [
    :anyone_can_add_self, :attachments, :color_id,
    :conference_data, :description, :finishes_at, :finishes_at_timezone, :starts_at, :starts_at_timezone,
    :extended_properties, :gadget, :location, :original_starts_at, :original_timezone_starts_at, :recurrence, :reminders,
    :self_sequence, :source_title, :source_url, :status, :summary, :transparency, :visibility,
  ]

  GOOGLE_EVENTS_ATTENDEES_FIELDS = [
    :email, :organizer, :response_status, :is_self,
    :comment, :resource, :optional, :additional_guests, :display_name
  ]

  def mount_body_remote_event
    event_google_params = self.slice(*GOOGLE_EVENTS_FIELDS).as_json.deep_symbolize_keys
    event_attendees_google_params = self.event_attendees.select(*GOOGLE_EVENTS_ATTENDEES_FIELDS).as_json

    event_google_params[:start] = {
      date_time: event_google_params[:starts_at],
      time_zone: event_google_params[:starts_at_timezone]
    }

    event_google_params[:end] = {
      date_time: event_google_params[:finishes_at],
      time_zone: event_google_params[:finishes_at_timezone]
    }

    event_google_params[:original_start_time] = {
      date_time: event_google_params[:original_starts_at],
      time_zone: event_google_params[:original_timezone_starts_at]
    }

    event_google_params[:source] = {
      title: event_google_params[:source_title],
      url: event_google_params[:source_url]
    }

    event_google_params[:attendees] = event_attendees_google_params.map do |event_attendee|
      event_attendee = event_attendee.as_json.deep_symbolize_keys
      event_attendee[:self] = event_attendee[:is_self]
      event_attendee.delete(:is_self)
      event_attendee.compact
    end

    keys_deleted_event = [:starts_at, :starts_at_timezone, :original_starts_at, :original_timezone_starts_at, :finishes_at, :finishes_at_timezone, :source_title, :source_url, :self_sequence]
    keys_deleted_event.each { |key| event_google_params.delete(key)}

    event_google_params
  end

  private
   
  def sync_create
    SyncGoogleUserEventsWorker.perform_async(self.id, 'create')
  end

  def sync_update
    SyncGoogleUserEventsWorker.perform_async(self.id, 'update')
  end

  def sync_delete
    SyncGoogleUserEventsWorker.perform_sync(self.id, 'delete')
  end
end
