require 'json'
require 'net/http'

require "google/apis/calendar_v3"
require 'googleauth'



class GoogleCalendarService
  def initialize(token)
    @token = token
    @client = get_client
  end

  def get_all_events
    calendar = @client
    now = Time.now.iso8601
    
    calendars = calendar.list_calendar_lists
    puts calendars
    items = calendar.fetch_all do |token|
      puts 'CALENDAR', token
      calendar.list_events('primary',
                            single_events: true,
                            order_by: 'startTime',
                            time_min: now,
                            page_token: token)
    end

    items.as_json
  end

  private 

  def get_client
    client = Google::Apis::CalendarV3::CalendarService.new
    client.authorization = @token
    client
  end
end
