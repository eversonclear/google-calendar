require 'json'
require 'net/http'

require "google/apis/calendar_v3"
require 'googleauth'



class GoogleCalendarService
  def initialize(token, current_user)
    @token = token
    @google_service = google_service
    @current_user = current_user
  end

  def get_all_events
    calendars = @google_service.list_calendar_lists
    
    calendars.items.each do |calendar_item|
      @calendar = Calendar.where(remote_id: calendar_item.id).first     
      
      if @calendar.present?
        @calendar.update(calendar_params(calendar_item))
      else
        @calendar = Calendar.create!(calendar_params(calendar_item))
      end

      events = list_calendar_events(calendar_item.id)
      events.items.each do |event_item|
        @event = Event.where(calendar_id: @calendar.id, remote_id: event_item.id).first     
        
      
        if @event.present?
          @event.update(event_params(event_item))
        else
          @calendar.events.create!(event_params(event_item))
        end
      end
    end
  end

  private 

  def google_service
    google_service = Google::Apis::CalendarV3::CalendarService.new
    google_service.authorization = @token
    google_service
  end

  def calendar_params(calendar)
    {
      user: @current_user,
      access_role: calendar.access_role,
      background_color: calendar.background_color,
      color_id: calendar.color_id,
      conference_properties: calendar.conference_properties.as_json,
      default_reminders: calendar.default_reminders,
      etag: calendar.etag,
      foreground_color: calendar.foreground_color,
      remote_id: calendar.id,
      kind: calendar.kind,
      selected: calendar.selected,
      summary: calendar.summary,
      time_zone: calendar.time_zone
    }
  end

  def event_params(event)
    {
      calendar: @calendar,
      user: @current_user,
      remote_created_at: event.created,
      remote_updated_at: event.updated,
      starts_at: event.start.date_time || event.start.date,
      starts_at_timezone: event.start.time_zone || '',
      finishes_at: event.end.date_time || event.end.date,
      finishes_at_timezone: event.end.time_zone || '',
      creator_email: event.creator.email,
      self_created: event.creator.self,
      etag: event.etag,
      event_type: event.event_type,
      html_link: event.html_link,
      i_cal_uid: event.i_cal_uid,
      remote_id: event.id,
      kind: event.kind,
      organizer_email: event.organizer.email,
      self_organized: event.organizer.self,
      reminders: event.reminders.as_json || { },
      status: event.status,
      summary: event.summary,
    }
  end

  def list_calendar_events(calendar_id)
    @google_service.list_events(calendar_id, 
                                single_events: true,
                                order_by: 'startTime',
                                time_min: Time.now.iso8601)                         
  end
end
