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

  trait :with_files do
    files { [fixture_file_upload("#{Rails.root}/spec/rails_helper.rb"),
             fixture_file_upload("#{Rails.root}/spec/spec_helper.rb")] }
  end
end
