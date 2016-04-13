FactoryGirl.define do
  factory :bucketlist do
    name { Faker::Superhero.power }

    factory :bucketlist_with_items do
      transient do
        amount 10
      end

      after(:create) do |list, evaluator|
        create_list(:item, evaluator.amount, bucketlist: list)
      end
    end
  end
end
