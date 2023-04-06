json.extract! event_attendee, :id, :event_id, :remote_id, :email, :organizer, :response_status, :is_self, :comment, :resource, :optional, :additional_guests, :display_name, :type, :response_status_time, :created_at, :updated_at
json.url event_attendee_url(event_attendee, format: :json)
