require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'Authorship' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    let(:question) { create(:question, user: user) }
    let(:another_question) { create(:question, user: another_user) }

    let(:answer) { create(:answer, question: question, user: user) }
    let(:another_answer) { create(:answer, question: question, user: another_user) }

    it 'of a question written by user' do
      expect(user).to be_author_of(question)
    end

    it 'of a question written by another user' do
      expect(user).to_not be_author_of(another_question)
    end
  end
end
