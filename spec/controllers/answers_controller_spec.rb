require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question_id: question.id, user: user) }
  let!(:reward) { create(:reward, rewardable: question) }

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

      it 'renders create view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders create view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Author' do
      before { login(user) }

      it "can't find deleted answer" do
        delete :destroy, params: { id: answer }, format: :js
        expect(assigns(:answer)).to be_destroyed
      end

      it 'render destroy view' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not an author' do
      let(:another_user) { create(:user) }
      before { login(another_user) }

      it 'tries to delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'error response' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response.status).to eq 403
      end
    end

    context 'Unauthorized user' do
      it 'tries to delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'needs to login in order to proceed' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response.body).to have_content 'You need to sign in or sign up before continuing'
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before { login(user) }
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { login(user) }
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Not an author' do
      let(:another_user) { create(:user) }
      before { login(another_user) }

      it 'tries to edit the answer' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end

      it 'error response' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response.status).to eq 403
      end
    end

    context 'Unauthorized user' do
      it 'tries to delete the answer' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end

      it 'needs to login in order to proceed' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response.body).to have_content 'You need to sign in or sign up before continuing'
      end
    end
  end

  describe 'PATCH #select_best' do
    let(:user2) { create(:user) }
    let!(:answer2) { create(:answer, question_id: question.id, user: user2) }

    # two scenarios for selecting best answer
    # one - when author of a question is not an author of an answer
    # second - when question and answer have the same author
    context 'Author of a question' do
      before { login(user) }
      it 'selects the best answer' do
        patch :select_best, params: { id: answer2, answer: { best: true } }, format: :js
        answer2.reload
        expect(answer2.best).to be_truthy
      end

      it 'renders select_best view' do
        patch :select_best, params: { id: answer2, answer: { best: true } }, format: :js
        expect(response).to render_template :select_best
      end
    end

    context 'Author of a question and answer' do
      before { login(user) }
      it 'selects the best answer' do
        patch :select_best, params: { id: answer, answer: { best: true } }, format: :js
        answer.reload
        expect(answer.best).to be_truthy
      end

      it 'renders select_best view' do
        patch :select_best, params: { id: answer, answer: { best: true } }, format: :js
        expect(response).to render_template :select_best
      end
    end

    context 'Not an author of a question' do
      let(:another_user) { create(:user) }
      before { login(another_user) }

      it 'tries to select the best answer' do
        patch :select_best, params: { id: answer, answer: { best: true } }, format: :js
        answer.reload
        expect(answer.best).to be_falsey
      end
    end

    context 'Unauthorized user' do
      it 'tries to select the best answer' do
        patch :select_best, params: { id: answer, answer: { best: true } }, format: :js
        answer.reload
        expect(answer.best).to be_falsey
      end
    end
  end

  it_behaves_like 'voted' do
    let(:author) { create(:user) }
    let(:user_voter) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:votable) { create(:answer, question_id: question.id, user: author) }
  end
end
