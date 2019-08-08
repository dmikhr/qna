FactoryBot.define do
  factory :comment do
    sequence :body do |n|
      "Comment body #{n}"
    end
  end

  trait :invalid_comment do
    body { nil }
  end
end
