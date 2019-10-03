require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:comment) { create(:comment, commentable: question, user: user) }

  describe 'GET #index' do
    it 'search question by query' do
      expect(Question).to receive(:search).with(question.title)
      get :index, params: { search: question.title, question: :question }
    end

    it 'search answer by query' do
      expect(Answer).to receive(:search).with(answer.body)
      get :index, params: { search: answer.body, answer: :answer }
    end

    it 'search comment by query' do
      expect(Comment).to receive(:search).with(comment.body)
      get :index, params: { search: comment.body, comment: :comment }
    end

    it 'search user by query' do
      expect(User).to receive(:search).with(user.email)
      get :index, params: { search: user.email, user: :user }
    end

    it 'render index view' do
      get :index
      expect(response).to render_template :index
    end
  end
end
