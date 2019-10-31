def schedules
  [].tap do |dates|
    5.times do |x|
      dates[x] = { date: (Time.zone.today - x.days) }
    end
  end
end

FactoryBot.define do
  factory :movie do
    name { Faker::Name.name }
    description { Faker::Movie.quote }
    image_url { Faker::LoremPixel.image }

    trait :with_schedules do
      schedules_attributes { schedules }   
    end
  end
end
