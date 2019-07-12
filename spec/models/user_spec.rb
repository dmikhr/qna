require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'Authorship' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    let(:question) { create(:question, user: user) }
    let(:another_question) { create(:question, user: another_user) }

    let(:answer) { create(:answer, question: question, user: user) }
    let(:another_answer) { create(:answer, question: question, user: another_user) }

    context 'of a question' do
      it 'written by user' do
        expect(user.is_author?(question)).to be(true)
      end

      it 'written by another user' do
        expect(user.is_author?(another_question)).to be(false)
      end
    end

    context 'of an answer' do
      it 'written by user' do
        expect(user.is_author?(answer)).to be(true)
      end

      it 'written by another user' do
        expect(user.is_author?(another_answer)).to be(false)
      end
    end
  end
end
