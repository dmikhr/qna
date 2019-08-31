require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    before { login(user) }

    before { get :show, params: { id: question } }

    it 'assigns a new answer to question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns new answer link to answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns question to current user' do
        post :create, params: { question: attributes_for(:question) }
        expect(question.user_id).to eq(user.id)
      end

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

      it "can't find deleted question" do
        delete :destroy, params: { id: question }
        expect(assigns(:question)).to be_destroyed
      end

      it 'redirects to list of questions' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Not an author' do

      before { login(another_user) }

      it 'tries to delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to list of questions' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to root_path
      end
    end

    context 'Unauthorized user' do
      it 'tries to delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to login page' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before { login(user) }
      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title for question', body: 'new body for question' } }, format: :js
        question.reload

        expect(question.title).to eq 'new title for question'
        expect(question.body).to eq 'new body for question'
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: { title: 'new title for question', body: 'new body for question' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { login(user) }
      it 'does not change question attributes' do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          expect(assigns(:question)).to eq question
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Not an author' do
      before { login(another_user) }

      it 'tries to edit the question' do
        patch :update, params: { id: question, question: { title: 'new title for question', body: 'new body for question' } }, format: :js
        question.reload

        expect(question.title).to_not eq 'new title for question'
        expect(question.body).to_not eq 'new body for question'
      end
    end

    context 'Unauthorized user' do
      it 'tries to edit the question' do
        patch :update, params: { id: question, question: { title: 'new title for question', body: 'new body for question' } }, format: :js
        question.reload

        expect(question.title).to_not eq 'new title for question'
        expect(question.body).to_not eq 'new body for question'
      end
    end
  end

  it_behaves_like 'voted' do
    let(:author) { create(:user) }
    let(:user_voter) { create(:user) }
    let!(:votable) { create(:question, user: author) }
  end

end
