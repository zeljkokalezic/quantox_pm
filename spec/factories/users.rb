FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.email }
  end
end