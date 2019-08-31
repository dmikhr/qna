require 'rails_helper'

RSpec.describe FilesController, type: :controller do

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) { create(:question,:with_files, user: user) }

  describe 'DELETE #destroy' do

    context 'Author' do
      before { login(user) }
      it 'deletes attached file' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to change(question.files, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not an author' do
      before { login(another_user) }
      it 'tries to delete attached file' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
      end

      it 'redirect to root path' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Unauthorized user' do
      it 'tries to delete attached file' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
      end

      it 'error response' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response.status).to eq 403
      end
    end
  end
end
