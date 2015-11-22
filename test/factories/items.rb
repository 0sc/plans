FactoryGirl.define do
  factory :item do
    name Faker::Lorem.sentence(3, true)
    done false
  end

end
