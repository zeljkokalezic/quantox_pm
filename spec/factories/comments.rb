FactoryGirl.define do
  factory :comment do
    text { Faker::StarWars.quote }

    association :user, factory: :user
    association :task, factory: :task
  end
end