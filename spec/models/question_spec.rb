require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_db_column(:title).of_type(:string) }
  it { should have_db_column(:body).of_type(:text) }


  it { should have_many(:votes) }

  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it { should validate_length_of(:title).is_at_least(10).is_at_most(150) }
  it { should validate_length_of(:body).is_at_least(10) }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'votable' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:votable) { create(:question, user: user) }
    let(:votable_down) { create(:question, user: user) }
  end
end
