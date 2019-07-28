require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:another_user) { create(:user) }
  let(:user_rewarded) { create(:user) }
  let!(:question) { create(:question, user: another_user) }
  let!(:reward) { create(:reward, rewardable: question, user: user_rewarded) }

  describe 'GET #index' do
    context 'Rewarded user'
      before { login(user_rewarded) }

      before { get :index }

      it 'populates an array of rewards' do
        expect(assigns(:rewards)).to eq([reward])
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
  end

  context 'Another user' do
    before { login(another_user) }

    before { get :index }

    it 'populates an array of rewards' do
      expect(assigns(:rewards)).to be_empty
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  context 'Unauthorized user' do
    before { get :index }

    it 'populates an array of rewards' do
      expect(assigns(:rewards)).to eq nil
    end

    it 'renders sign in view' do
      expect(response.body).to include 'sign_in'
    end
  end
end
