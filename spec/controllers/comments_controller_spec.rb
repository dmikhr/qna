require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'Comment POST #create for question' do

    context 'with valid attributes' do
      before { login(user) }

      it 'assigns comment to current user' do
        post :create, params: { question_id: question.id, comment: attributes_for(:comment) }, format: :js
        expect(assigns(:comment).user_id).to eq(user.id)
      end

      it 'saves a new comment in the database' do
        expect { post :create, params: { question_id: question.id, comment: attributes_for(:comment), format: :js } }.to change(question.comments, :count).by(1)
      end

      it 'renders create view' do
        post :create, params: { question_id: question.id, comment: attributes_for(:comment), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not save the comment' do
        expect { post :create, params: { question_id: question.id, comment: attributes_for(:comment, :invalid_comment), format: :js } }.to_not change(question.comments, :count)
      end

      it 'renders create view' do
        post :create, params: { question_id: question.id, comment: attributes_for(:comment, :invalid_comment), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'Unauthorized user' do
      it 'tries to add comment' do
        expect { post :create, params: { question_id: question.id, comment: attributes_for(:comment), format: :js } }.to_not change(question.comments, :count)
      end
    end
  end

  describe 'Comment POST #create for answer' do

    context 'with valid attributes' do
      before { login(user) }

      it 'assigns comment to current user' do
        post :create, params: { answer_id: answer.id, comment: attributes_for(:comment) }, format: :js
        expect(assigns(:comment).user_id).to eq(user.id)
      end

      it 'saves a new comment in the database' do
        expect { post :create, params: { answer_id: answer.id, comment: attributes_for(:comment), format: :js } }.to change(answer.comments, :count).by(1)
      end

      it 'renders create view' do
        post :create, params: { answer_id: answer.id, comment: attributes_for(:comment), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not save the comment' do
        expect { post :create, params: { answer_id: answer.id, comment: attributes_for(:comment, :invalid_comment), format: :js } }.to_not change(question.comments, :count)
      end

      it 'renders create view' do
        post :create, params: { answer_id: answer.id, comment: attributes_for(:comment, :invalid_comment), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'Unauthorized user' do
      it 'tries to add comment' do
        expect { post :create, params: { question_id: question.id, comment: attributes_for(:comment), format: :js } }.to_not change(question.comments, :count)
      end
    end
  end
end
