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

    trait :with_files do
      files { [fixture_file_upload("#{Rails.root}/spec/rails_helper.rb"),
               fixture_file_upload("#{Rails.root}/spec/spec_helper.rb")] }
    end
  end
end
