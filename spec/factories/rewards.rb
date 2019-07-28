FactoryBot.define do
  factory :reward do
    name { "My reward" }
  end
  trait :with_picture do
    picture { fixture_file_upload("#{Rails.root}/app/assets/images/reward_medal.png") }
  end
end
