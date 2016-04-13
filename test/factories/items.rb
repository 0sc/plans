FactoryGirl.define do
  factory :item do
    name { Faker::StarWars.quote }
    done false
  end
end
