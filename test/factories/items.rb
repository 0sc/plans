FactoryGirl.define do
  factory :item do
    name { Faker::StarWars.quote[0..50] }
    done false
  end
end
