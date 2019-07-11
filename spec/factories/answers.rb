FactoryBot.define do
  factory :answer do
    sequence :body do |n|
      "Answer body #{n}"
    end
    question { nil }
  end

  trait :invalid do
    body { nil }
  end
end
