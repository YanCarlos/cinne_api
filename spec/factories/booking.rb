FactoryBot.define do
  factory :booking do
    name { Faker::Name.name }
    identification { Faker::Number.number(10) }
    phone { Faker::PhoneNumber.cell_phone }
    email { Faker::Internet.email }
    schedule
  end
end
