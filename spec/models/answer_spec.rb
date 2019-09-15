require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should have_db_column(:body).of_type(:text) }
  it { should have_db_column(:best).of_type(:boolean) }
  it { should have_db_column(:user_id).of_type(:integer) }

  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  describe 'select_best method' do
    let(:user) { create(:user) }
    let(:user_rewarded) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answers) { create_list(:answer, 5, question: question, user: user) }
    let(:answer_best) { create(:answer, question: question, user: user_rewarded) }
    let!(:reward) { create(:reward, rewardable: question) }

    it 'select answer as best' do
      expect{ answers[-1].select_best }.to change{ answers[-1].best }.from(false).to(true)
      answers[0, answers.size - 1].each { |answer| expect(answer.best).to be false }
    end

    it 'best answer is first in the list' do
      expect(question.answers.first).to_not eq answers[-1]
      answers[-1].select_best
      expect(question.answers.first).to eq answers[-1]
    end

    it 'setting new best answer' do
      expect do
        answers[-1].select_best
        answers[0].select_best
        answers[-1].reload
        answers[0].reload
      end.to change{ answers[0].best }.from(false).to(true)
    end

    it 'old best answer is not best now' do
      answers[-1].select_best

      expect do
        answers[0].select_best
        answers[0].reload
        answers[-1].reload
      end.to change{ answers[-1].best }.from(true).to(false)
    end

    it 'set reward to author of an answer' do
      expect(question.reward.user).to eq nil
      answer_best.select_best
      expect(question.reward.user).to eq user_rewarded
    end
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'votable' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:votable) { create(:question, user: user) }
    let(:votable_down) { create(:question, user: user) }
  end

  it_behaves_like 'commentable'
end
