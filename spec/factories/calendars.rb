FactoryBot.define do
  factory :calendar do
    user { nil }
    access_role { "MyString" }
    background_color { "MyString" }
    color_id { "MyString" }
    default_reminders { "MyText" }
    conference_properties { "MyText" }
    etag { "MyString" }
    foreground_color { "MyString" }
    remote_id { "MyString" }
    kind { "MyString" }
    selected { false }
    summary { "MyString" }
    time_zone { "MyString" }
  end
end
