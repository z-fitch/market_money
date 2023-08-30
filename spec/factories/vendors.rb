FactoryBot.define do
  factory :vendor do
    name { Faker::TvShows::BrooklynNineNine.character }
    description { Faker::TvShows::BrooklynNineNine.quote }
    contact_name { Faker::Name.name }
    contact_phone { Faker::PhoneNumber.cell_phone }
    credit_accepted { Faker::Boolean.boolean }
  end
end