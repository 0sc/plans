FactoryGirl.define do
  factory :user do
    name Faker::Name.name
    email Faker::Internet.email
    password "pass"

    factory :user_with_bucketlist do
      transient do
        amount 10
      end

      after(:create) do |user, evaluator|
        create_list(:bucketlist, evaluator.amount, user: user)
      end
    end
  end
end
