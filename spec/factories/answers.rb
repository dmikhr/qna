FactoryBot.define do
  factory :answer do
    body { "MyText for answer" }
    question { nil }
  end
  trait :invalid do
    body { nil }
  end
end
