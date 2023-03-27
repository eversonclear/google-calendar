FactoryBot.define do
  factory :event_attendee do
    event { nil }
    remote_id { "MyString" }
    email { "MyString" }
    organizer { false }
    response_status { "MyString" }
    is_self { false }
    comment { "MyString" }
    resource { false }
    optional { false }
    additional_guests { 1 }
    display_name { "MyString" }
    type { "" }
    response_status_time { "2023-03-27 10:38:35" }
  end
end
