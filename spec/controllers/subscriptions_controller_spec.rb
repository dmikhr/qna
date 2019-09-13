require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:subscription) { create(:subscription, user: user, subscribable: question) }

  describe 'POST #create' do
    context 'user' do
      before { login(user) }

      it 'subscribes to notifications' do
        expect { post :create, params: { id: question.id } }.to change(Subscription, :count).by(1)
      end
    end

    context 'unauthenticated user' do
      it 'cannot subscribe to notifications' do
        expect { post :create, params: { id: question.id } }.to_not change(Subscription, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'user' do
      before { login(user) }

      it "unsubscribe" do
        delete :destroy, params: { id: question.id }
        expect(assigns(:subscription)).to be_destroyed
      end
    end

    context 'unauthenticated user' do
      it 'cannot unsubscribe' do
        delete :destroy, params: { id: question.id }
        expect { post :destroy, params: { id: question.id } }.to_not change(Subscription, :count)
      end
    end
  end
end
