require 'sphinx_helper'
require 'rails_helper'

RSpec.describe Services::Search do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:comment) { create(:comment, commentable: question, user: user) }

  describe 'Search' do
    it 'search items' do
      items = { question: question.title,
                answer: answer.body,
                comment: comment.body,
                user: user.email }

      items.each do |item, query|
        expect(item.to_s.capitalize.constantize).to receive(:search).with(query)
        Services::Search.call([item], query)
      end
    end
  end
end
