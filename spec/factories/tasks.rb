FactoryGirl.define do
  factory :task do
    name { Faker::StarWars.planet }
    description { Faker::StarWars.quote }
    priority { 0 }
    status { 1 }
    deadline { Time.now }

    association :user, factory: :user
    association :project, factory: :project
  end
end