FactoryBot.define do
  factory :event do
    user { nil }
    calendar { nil }
    remote_created_at { "2023-03-27 10:38:32" }
    remote_updated_at { "2023-03-27 10:38:32" }
    starts_at { "2023-03-27 10:38:32" }
    starts_at_timezone { "MyString" }
    finishes_at { "2023-03-27 10:38:32" }
    finishes_at_timezone { "MyString" }
    self_sequence { 1 }
    location { "MyString" }
    description { "MyString" }
    creator_email { "MyString" }
    creator_id { "MyString" }
    creator_display_name { "MyString" }
    self_created { false }
    etag { "MyString" }
    event_type { "MyString" }
    web_link { "MyString" }
    i_cal_uid { "MyString" }
    remote_id { "MyString" }
    kind { "MyString" }
    organizer_email { "MyString" }
    organizer_id { "MyString" }
    organizer_display_name { "MyString" }
    self_organized { false }
    reminders { "MyText" }
    status { "MyString" }
    summary { "MyString" }
    transparency { "MyString" }
    recurrence { "MyText" }
    allow_new_time_proposals { false }
    body_content_type { "MyString" }
    body_content { "MyString" }
    categories { "MyText" }
    change_key { "MyString" }
    has_attachments { false }
    importance { "MyString" }
    is_all_day { false }
    is_cancelled { false }
    is_draft { false }
    is_online_meeting { false }
    is_organizer { false }
    end_time_unspecified { false }
    is_reminder_on { false }
    locations { "MyText" }
    online_meeting { "MyText" }
    online_meeting_provider { "MyString" }
    online_meeting_url { "MyString" }
    original_starts_at { "2023-03-27 10:38:32" }
    original_timezone_starts_at { "MyString" }
    reminder_minutes_before_start { 1 }
    series_master_id { "MyString" }
    response_status_text { "MyString" }
    response_status_time { "2023-03-27 10:38:32" }
    response_requested { false }
    show_as { "MyString" }
    transaction_id { "MyString" }
    visibility { "MyString" }
    attendees_omitted { false }
    extended_properties { "MyText" }
    hangout_link { "MyString" }
    conference_data { "MyText" }
    gadget { "MyText" }
    anyone_can_add_self { false }
    guests_can_invite_others { false }
    guests_can_modify { false }
    guests_can_see_other_guests { false }
    private_copy { false }
    locked { false }
    source_url { "MyString" }
    source_title { "MyString" }
    color_id { "MyString" }
    working_location_properties { "MyText" }
    attachments { "MyText" }
    original_finishes_at_timezone { "MyString" }
  end
end
