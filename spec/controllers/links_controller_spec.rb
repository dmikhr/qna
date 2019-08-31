require 'rails_helper'

RSpec.describe LinksController, type: :controller do

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:link) { create(:link, linkable: question) }

  describe 'DELETE #destroy' do
    context 'Author of a question' do
      before { login(user) }
      it 'deletes attached link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to change(question.links, :count).by(-1)
      end
    end

    it 'renders destroy view' do
      delete :destroy, params: { id: link }, format: :js
      expect(response).to render_template :destroy
    end
  end

  context 'Not an author' do
    before { login(another_user) }
    it 'tries to delete attached link' do
      expect { delete :destroy, params: { id: link }, format: :js }.to_not change(question.links, :count)
    end

    it 'error response' do
      delete :destroy, params: { id: link }, format: :js
      expect(response.status).to eq 403
    end
  end

  context 'Unauthorized user' do
    it 'tries to delete attached link' do
      expect { delete :destroy, params: { id: link }, format: :js }.to_not change(question.links, :count)
    end

    it 'error response' do
      delete :destroy, params: { id: link }, format: :js
      expect(response.status).to eq 403
    end
  end
end
