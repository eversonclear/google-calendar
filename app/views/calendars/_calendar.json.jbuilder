json.extract! calendar, :id, :user_id, :access_role, :background_color, :color_id, :description, :default_reminders, :conference_properties, :etag, :foreground_color, :remote_id, :kind, :selected, :summary, :summary_override, :primary, :deleted, :hidden, :time_zone, :notification_settings, :location, :can_edit, :can_share, :can_view_private_items, :change_key, :allowed_online_meeting_providers, :web_link, :default_online_meeting_provider, :is_tallying_responses, :is_default_calendar, :is_removable, :owner_name, :owner_email, :status, :created_at, :updated_at
json.url calendar_url(calendar, format: :json)