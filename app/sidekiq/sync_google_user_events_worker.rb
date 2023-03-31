class SyncGoogleUserEventsWorker
  Sidekiq.strict_args!(false)
  include Sidekiq::Job

  def perform(current_user_id, calendar_id, event_id, action)
    @current_user = User.find(current_user_id)
    @calendar = calendar_id ? Calendar.find(calendar_id) : nil
    @event = event_id ? Event.find(event_id) : nil
    @action = action

    @body = @event.mount_body_remote_event.deep_symbolize_keys.deep_compact if event_id

    refresh_token_if_invalid
    set_google_calendar_service
    perform_action
  end

  def perform_action
    case @action
    when 'create'
      @google_calendar_service.insert_event(@calendar.remote_id, @body) do |result, err|
        if err
          puts "Insert event failed: #{err}"
        else
          @event.update(remote_id: result.as_json["id"])
        end
      end
    when 'update'
      @google_calendar_service.update_event(@calendar.remote_id, @event.remote_id, @body) do |result, err|
        if err
          puts "Update event failed: #{err}"
        else
          puts "Update event successfully"
        end
      end
    when 'delete'
      @google_calendar_service.delete_event(@calendar.remote_id, @event.remote_id) do |result, err|
        if err
          puts "Delete event failed: #{err}"
        else
          puts "Delete event successfully"
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
