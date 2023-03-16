class UpdateCalendarsEventsJob
  include Sidekiq::Job

  def perform(current_user_id)
    @current_user = User.find(current_user_id)
    refresh_token_if_invalid
    set_google_calendar_service
    update_user_calendars
  end

  def refresh_token_if_invalid
    @google_service = GoogleService.new

    if !@google_service.access_token_is_valid?(@current_user.google_expire_token)
      data_token = @google_service.refresh_token(@current_user.google_refresh_token)
      @current_user.update(google_token: data_token["access_token"], google_expire_token: Time.now + data_token['expires_in'])
    end
  end

  def update_user_calendars
    calendars = @google_calendar_service.list_calendar_lists
    
    calendars.items.each do |calendar_item|
      @calendar = Calendar.where(remote_id: calendar_item.id).first     
      
      if @calendar.present?
        @calendar.update(calendar_params(calendar_item))
      else
        @calendar = Calendar.create!(calendar_params(calendar_item))
      end

      events = @google_calendar_service.list_events(calendar_item.id, 
                                          time_min: Time.now.iso8601)

      events.items.each do |event_item|
        @event = Event.where(calendar_id: @calendar.id, remote_id: event_item.id).first             
        if @event.present?
          @event.update(event_params(event_item))
        else
          @event = @calendar.events.create!(event_params(event_item))
        end

        if event_item.attendees.present?
          event_item.attendees.each do |event_attendee|
            @event_attendee = EventAttendee.where(event_id: @event.id, email: event_attendee.email).first  
            
            if @event_attendee.present?
              @event_attendee.update(event_attendee_params(event_attendee))
            else
              @event.event_attendees.create!(event_attendee_params(event_attendee))
            end
          end
        end
      end
    end
  end

  private 

  def set_google_calendar_service
    token = AccessTokenService.new @current_user.google_token

    @google_calendar_service = Google::Apis::CalendarV3::CalendarService.new
    @google_calendar_service.authorization = token
  end

  def calendar_params(calendar)
    {
      user: @current_user,
      access_role: calendar.access_role,
      background_color: calendar.background_color,
      color_id: calendar.color_id,
      conference_properties: calendar.conference_properties.as_json,
      default_reminders: calendar.default_reminders,
      etag: calendar.etag.gsub('"', ""),
      foreground_color: calendar.foreground_color,
      remote_id: calendar.id,
      kind: calendar.kind,
      selected: calendar.selected,
      summary: calendar.summary,
      time_zone: calendar.time_zone,
      deleted: calendar.deleted,
      description: calendar.description || '',
      summary_override: calendar.summary_override || '',
      primary: calendar.primary,
      hidden: calendar.hidden

    }
  end

  def event_params(event)
    {
      calendar: @calendar,
      user: @current_user,
      sequence: event.sequence,
      location: event.location || '',
      description: event.description || '',
      remote_created_at: event.created,
      remote_updated_at: event.updated,
      starts_at: event.start.date_time || event.start.date,
      starts_at_timezone: event.start.time_zone || '',
      finishes_at: event.end.date_time || event.end.date,
      finishes_at_timezone: event.end.time_zone || '',
      creator_email: event.creator.email,
      self_created: event.creator.self,
      etag: event.etag.gsub('"', ""),
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
      transparency: event.transparency || "",
      recurrences: event.recurrence
    }
  end

  def event_attendee_params(event_attendee)
    {
      event: @event,
      email: event_attendee.email,
      organizer: event_attendee.organizer,
      response_status: event_attendee.response_status,
      self: event_attendee.self,
    }
  end
end
