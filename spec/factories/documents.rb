FactoryGirl.define do
  factory :document do
    filename { Faker::StarWars.planet }
    content_type { Faker::StarWars.planet }
    file_contents { Faker::StarWars.planet }
    size { 1 }
    
    association :comment, factory: :comment
  end
end