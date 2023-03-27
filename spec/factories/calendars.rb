FactoryBot.define do
  factory :calendar do
    user { nil }
    access_role { "MyString" }
    background_color { "MyString" }
    color_id { "MyString" }
    description { "MyString" }
    default_reminders { "MyText" }
    conference_properties { "MyText" }
    etag { "MyString" }
    foreground_color { "MyString" }
    remote_id { "MyString" }
    kind { "MyString" }
    selected { false }
    summary { "MyString" }
    summary_override { "MyString" }
    primary { false }
    deleted { false }
    hidden { false }
    time_zone { "MyString" }
    notification_settings { "MyText" }
    location { "MyString" }
    can_edit { false }
    can_share { false }
    can_view_private_items { false }
    change_key { "MyString" }
    allowed_online_meeting_providers { "MyString" }
    web_link { "MyString" }
    default_online_meeting_provider { "MyString" }
    is_tallying_responses { false }
    is_default_calendar { false }
    is_removable { false }
    owner_name { "MyString" }
    owner_email { "MyString" }
    status { "MyString" }
  end
end
