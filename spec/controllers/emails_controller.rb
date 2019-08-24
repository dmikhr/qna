require 'rails_helper'

RSpec.describe User::EmailsController, type: :controller do
  describe 'POST #submit_email' do
    let(:user) { create(:user) }

    it 'redirects to log in page' do
      get :submit_email, params: { email: user.email }

      expect(response).to redirect_to new_user_session_path
    end
  end
end
