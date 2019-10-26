FactoryBot.define do
  factory :schedule do
    date { Time.zone.today }
    movie
  end
end
