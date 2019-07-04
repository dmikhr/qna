FactoryBot.define do
  factory :question do
    title { "MyString for question" }
    body { "MyText for question" }

    trait :invalid do
      title { nil }
    end
  end
end
