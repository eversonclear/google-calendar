class SyncGoogleUserEventsWorker
  Sidekiq.strict_args!(false)
  include Sidekiq::Job

  def perform(current_user_id, calendar_remote_id, event_remote_id, action, body=nil)
    @current_user = User.find(current_user_id)
    @calendar_remote_id = calendar_remote_id
    @event_remote_id = event_remote_id
    @action = action
    @body = body
    set_google_calendar_service
    
    perform_action
  end

  def perform_action
    puts @body.deep_symbolize_keys
    case @action
    when 'create'
      @google_calendar_service.insert_event(@calendar_remote_id, @body.deep_symbolize_keys) do |result, err|
        if err
          puts 'ERRO', err.as_json
        else
          puts 'EVENT CREATED'
        end
      end
    when 'update'
      @google_calendar_service.patch_event(@calendar_remote_id, @event_remote_id, @body.deep_symbolize_keys) do |result, err|
        if err
          puts 'ERRO', err.as_json
        else
          puts 'EVENT UPDATED'
        end
      end
    when 'delete'
      @google_calendar_service.delete_event(@calendar_remote_id, @event_remote_id) do |result, err|
        if err
          puts 'ERRO', err.as_json
        else
          puts 'EVENT DELETED'
        end
      end
    else
      puts 'unknown action'
    end    
  end

  def set_google_calendar_service
    token = AccessTokenService.new @current_user.google_token

    @google_calendar_service = Google::Apis::CalendarV3::CalendarService.new
    @google_calendar_service.authorization = token
  end
end
