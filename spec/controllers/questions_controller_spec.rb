require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    before { login(user) }

    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Author' do
      before { login(user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it "can't find deleted question" do
        delete :destroy, params: { id: question }
        expect { Question.find(question.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      end

      it 'redirects to list of questions' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Not an author' do
      let(:another_user) { create(:user) }
      before { login(another_user) }

      it 'tries to delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it "can find the question" do
        delete :destroy, params: { id: question }
        expect(Question.find(question.id)).to eq(question)
      end

      it 'redirects to list of questions' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Unauthorized user' do
      it 'tries to delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it "can find the question" do
        delete :destroy, params: { id: question }
        expect(Question.find(question.id)).to eq(question)
      end

      it 'redirects to login page' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
