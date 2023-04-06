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
    response_status_time { "2023-04-06 09:31:54" }
  end
end
