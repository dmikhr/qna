FactoryBot.define do
  factory :question do
    sequence :title do |n|
      "Question title #{n}"
    end
    sequence :body do |n|
      "Body of a question number #{n}"
    end

    trait :invalid do
      title { nil }
    end
  end
end
