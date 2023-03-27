class UpdateUserCalendarsGoogleJob
  include Sidekiq::Job

  def perform(current_user_id, calendar_ids = [])
    @current_user = User.find(current_user_id)
    @calendar_ids = calendar_ids
    @calendar_remote_ids=[]
    @event_remote_ids=[]
    @event_attendee_remote_ids=[]
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

    # Calendars
    calendars = @google_calendar_service.list_calendar_lists
    
    calendars.items.each do |calendar_item|
      @calendar_remote_ids << calendar_item.id
      break if @calendar_ids.present? && !@calendar_ids.include?(calendar_item.id)

      @calendar = Calendar.where(remote_id: calendar_item.id).first     
      
      if @calendar.present?
        @calendar.update(calendar_params(calendar_item))
      else
        @calendar = Calendar.create!(calendar_params(calendar_item))
      end

      # Events
      events = @google_calendar_service.list_events(calendar_item.id, 
                                          time_min: Time.now.iso8601)

      events.items.each do |event_item|
        @event_remote_ids << event_item.id
        @event = Event.where(calendar_id: @calendar.id, remote_id: event_item.id).first             
        if @event.present?
          @event.update(event_params(event_item))
        else
          @event = @calendar.events.create!(event_params(event_item))
        end

        # Event Attendees
        if event_item.attendees.present?
          event_item.attendees.each do |event_attendee|
            @event_attendee_remote_ids << calendar_item.id
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

    remove_records_nonexistent
  end

  private 

  def remove_records_nonexistent
    Calendar.where.not(remote_id: @calendar_remote_ids).destroy_all
    Event.where.not(remote_id: @event_remote_ids).destroy_all
    EventAttendee.where.not(remote_id: @event_attendee_remote_ids).destroy_all
  end

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
      hidden: calendar.hidden,
      location: calendar.location,
      notification_settings: calendar.notification_settings.as_json
    }
  end

  def event_params(event)
    {
      calendar: @calendar,
      user: @current_user,
      self_sequence: event.sequence,
      location: event.location || '',
      description: event.description || '',
      remote_created_at: event.created,
      remote_updated_at: event.updated,
      starts_at: event.start.date_time || event.start.date,
      starts_at_timezone: event.start.time_zone || '',
      finishes_at: event.end.date_time || event.end.date,
      finishes_at_timezone: event.end.time_zone || '',
      creator_email: event.creator.email,
      creator_id: event.creator.id,
      creator_display_name: event.creator.display_name,
      self_created: event.creator.self,
      etag: event.etag.gsub('"', ""),
      event_type: event.event_type,
      web_link: event.html_link,
      i_cal_uid: event.i_cal_uid,
      remote_id: event.id,
      kind: event.kind,
      organizer_email: event.organizer.email,
      organizer_display_name: event.organizer.display_name,
      organizer_id: event.organizer.id,
      self_organized: event.organizer.self,
      reminders: event.reminders.as_json || { },
      status: event.status,
      summary: event.summary,
      transparency: event.transparency || "",
      recurrence: event.recurrence,
      end_time_unspecified: event.end_time_unspecified,
      visibility: event.visibility,
      attendees_omitted: event.attendees_omitted,
      extended_properties: event.extended_properties,
      hangout_link: event.hangout_link,
      conference_data: event.conference_data.as_json,
      gadget: event.gadget,
      anyone_can_add_self: event.anyone_can_add_self,
      guests_can_invite_others: event.guests_can_invite_others,
      guests_can_modify: event.guests_can_modify,
      guests_can_see_other_guests: event.guests_can_see_other_guests,
      private_copy: event.private_copy,
      locked: event.locked,
      source_url: event.source ? event.source.url : nil ,
      source_title:event.source ? event.source.title : nil,
      working_location_properties: event.working_location_properties,
      attachments: event.attachments
    }
  end

  def event_attendee_params(event_attendee)
    {
      event: @event,
      email: event_attendee.email,
      organizer: event_attendee.organizer,
      response_status: event_attendee.response_status,
      is_self: event_attendee.self,
      additional_guests: event_attendee.additional_guests,
      comment: event_attendee.comment,
      display_name: event_attendee.display_name,
      remote_id: event_attendee.id,
      optional: event_attendee.optional,
    }
  end
end
