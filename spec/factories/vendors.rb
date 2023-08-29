FactoryBot.define do
  factory :vendor do
    name { Faker::Company.name }
    description { Faker::Restaurant.description }
    contact_name { Faker::Name.name }
    contact_phone { Faker::PhoneNumber.cell_phone }
    credit_accepted { Faker::Boolean.boolean }
  end
end