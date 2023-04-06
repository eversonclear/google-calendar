class SyncGoogleUserEventsWorker
  include Sidekiq::Job

  def perform(event_id, calendar_ids, action)
    @action = action
    @event = Event.find(event_id)
    @current_user = User.find(1)
    @calendars = Calendar.where(calendar_id: calendar_ids)

    @body = @event.mount_body_remote_event.deep_symbolize_keys.deep_compact if @event

    refresh_token_if_invalid
    set_google_calendar_service
    perform_action
  end

  def perform_action
    case @action
    when 'create'
      @calendar_ids.map do |calendar_id| 
        @body = @event.mount_body_remote_event.deep_symbolize_keys.deep_compact if @event

        @google_calendar_service.insert_event(@calendar.remote_id, @body) do |result, err|
          if err
            puts "Insert event failed: #{err}"
          else
            ExternalEvent.create!(calendar_id: @event.calendar.id, event_id: @event.id, external_id: result.as_json["id"])
          end
        end
      end  
    when 'update'
      @event.external_events.each do |external_event|
        @google_calendar_service.update_event(external_event.calendar.remote_id, external_events.external_id, @body) do |result, err|
          if err
            puts "Update event failed: #{err}"
          else
            puts "Update event successfully"
          end
        end
      end 
    when 'delete'
      @event.external_events.each do |external_event|
        @google_calendar_service.delete_event(external_event.calendar.remote_id, external_event.external_id) do |result, err|
          if err
            puts "Delete event failed: #{err}"
          else
            puts "Delete event successfully"
          end
        end
      end
    else
      puts 'Unknown action'
    end    
  end

  def set_google_calendar_service
    token = AccessTokenService.new @current_user.google_token

    @google_calendar_service = Google::Apis::CalendarV3::CalendarService.new
    @google_calendar_service.authorization = token
  end

  def refresh_token_if_invalid
    @google_service = GoogleService.new

    if !@google_service.access_token_is_valid?(@current_user.google_expire_token)
      data_token = @google_service.refresh_token(@current_user.google_refresh_token)
      @current_user.update(google_token: data_token["access_token"], google_expire_token: Time.now + data_token['expires_in'])
    end
  end
end