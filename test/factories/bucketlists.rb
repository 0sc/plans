FactoryGirl.define do
  factory :bucketlist do
    name Faker::Lorem.characters(10)

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
