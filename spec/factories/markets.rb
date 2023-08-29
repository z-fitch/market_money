FactoryBot.define do
  factory :market do
    name { Faker::Hacker.say_something_smart }
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    country { Faker::Address.country }
    state { Faker::Address.state }
    zip { Faker::Address.zip }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
  end
end
