require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question_id: question.id, user: user) }

  describe 'GET #new' do
    before { login(user) }

    before { get :new, params: { question_id: question.id } }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    before { login(user) }

    before { get :show, params: { id: answer } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns answer to current user' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }, format: :js
        expect(answer.user_id).to eq(user.id)
      end

      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 'redirects to question show view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Author' do
      before { login(user) }

      it "can't find deleted answer" do
        delete :destroy, params: { id: answer }
        expect(assigns(:answer)).to be_destroyed
      end

      it 'redirects to list of questions' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Not an author' do
      let(:another_user) { create(:user) }
      before { login(another_user) }

      it 'tries to delete the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirects to list of questions' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Unauthorized user' do
      it 'tries to delete the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirects to login page' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
