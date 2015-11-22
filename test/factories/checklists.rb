FactoryGirl.define do
  factory :checklist do
    name Faker::Lorem.characters(10)

    factory :checklist_with_items do
      transient do
        amount 10
      end

      after(:create) do |list, evaluator|
        create_list(:item, evaluator.amount, checklist: list)
      end
    end
  end

end
