require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_db_column(:title).of_type(:string) }
  it { should have_db_column(:body).of_type(:text) }

  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it { should validate_length_of(:title).is_at_least(10).is_at_most(150) }
  it { should validate_length_of(:body).is_at_least(10) }
end
