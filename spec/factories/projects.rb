FactoryGirl.define do
  factory :project do
    name { Faker::StarWars.planet }
    description { Faker::StarWars.quote }
    association :user, factory: :user
  end
end