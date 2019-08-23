require 'rails_helper'

RSpec.describe User::EmailsController, type: :controller do
  describe 'POST #submit_email' do
    let(:user) { create(:user) }

    before { get :submit_email, params: { email: user.email } }

    it 'redirects to log in page' do
      expect(response).to redirect_to new_user_session_path
    end
  end
end
