FactoryBot.define do
  factory :answer do
    sequence :body do |n|
      "Answer body #{n}"
    end
    question
  end

  trait :invalid do
    body { nil }
  end
end
