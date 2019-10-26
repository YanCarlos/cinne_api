FactoryBot.define do
  factory :movie do
    name { Faker::Name.name }
    description { Faker::Movie.quote }
    image_url { Faker::LoremPixel.image }

    trait :with_schedules do
      after(:create) do |movie|
        5.times do |x|
          create(:schedule, date: (Time.zone.today - x.days), movie: movie)
        end
      end
    end
  end
end
