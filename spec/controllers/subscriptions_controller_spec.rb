require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:question2) { create(:question, user: another_user) }
  let!(:subscription_another) { create(:subscription, user: another_user, subscribable: question2) }

  describe 'POST #create' do
    context 'user' do
      before { login(user) }

      it 'subscribes to notifications' do
        expect { post :create, params: { id: question.id, format: :js } }.to change(Subscription, :count).by(1)
      end

      it 'assigns subscription to current user' do
        post :create, params: { id: question.id, format: :js }
        expect(assigns(:subscription).user).to eq user
      end

      it 'creates subscription to a given question' do
        post :create, params: { id: question.id, format: :js }
        expect(assigns(:subscription).subscribable).to eq question
      end
    end

    context 'unauthenticated user' do
      it 'cannot subscribe to notifications' do
        expect { post :create, params: { id: question.id, format: :js } }.to_not change(Subscription, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'user' do
      before { login(user) }

      it "unsubscribe" do
        delete :destroy, params: { id: question.id, format: :js }
        expect(assigns(:subscription)).to be_destroyed
      end

      it "tries to unsubscribe from another user subscription" do
        expect { delete :destroy, params: { id: question2.id, format: :js } }.to raise_exception ActiveRecord::RecordNotFound
      end
    end

    context 'unauthenticated user' do
      it 'cannot unsubscribe' do
        expect { delete :destroy, params: { id: question.id, format: :js } }.to raise_exception ActiveRecord::RecordNotFound
      end
    end
  end
end
