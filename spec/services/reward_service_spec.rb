require 'rails_helper'

RSpec.describe RewardService, type: :service do
  describe 'RewardService' do
    let(:user) { create(:user) }
    let(:user_rewarded) { create(:user) }

    let(:question) { create(:question, user: user) }
    let!(:reward) { create(:reward, rewardable: question) }

    it 'assigns reward to user' do
      expect(question.reward.user).to eq nil

      RewardService.new(user_rewarded, question).call

      expect(question.reward.user).to eq user_rewarded
    end
  end
end
