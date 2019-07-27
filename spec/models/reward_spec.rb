require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should have_db_column(:name).of_type(:string) }

  it { should belong_to :rewardable }

  it { should validate_presence_of :name }

  it 'has one attached picture' do
    expect(Reward.new.picture).to be_an_instance_of(ActiveStorage::Attached::One)
  end

end
