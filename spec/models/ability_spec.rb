require 'rails_helper'
require "cancan/matchers"

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create(:question, user: user) }
    let(:question_other) { create(:question, user: other) }


    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context '#create' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
    end

    context '#update' do
      it { should be_able_to :update, create(:question, user: user) }
      it { should_not be_able_to :update, create(:question, user: other) }

      it { should be_able_to :update, create(:answer, question: question, user: user) }
      it { should_not be_able_to :update, create(:answer, question: question, user: other) }
    end

    context '#destroy' do
      it { should be_able_to :destroy, create(:question, user: user) }
      it { should_not be_able_to :destroy, create(:question, user: other) }

      it { should be_able_to :destroy, create(:answer, question: question, user: user) }
      it { should_not be_able_to :destroy, create(:answer, question: question, user: other) }

      it { should be_able_to :destroy, create(:link, linkable: question) }
      it { should_not be_able_to :destroy, create(:link, linkable: question_other) }

      it { should be_able_to :destroy, ActiveStorage::Attachment }
    end

    context 'voting' do
      [:upvote, :cancel_vote, :downvote].each do |action|
        it { should be_able_to action, create(:question, user: other) }
        it { should_not be_able_to action, create(:question, user: user) }

        it { should be_able_to action, create(:answer, question: question, user: other) }
        it { should_not be_able_to action, create(:answer, question: question, user: user) }
      end
    end

    context 'select best answer' do
      it { should be_able_to :select_best, create(:answer, question: question, user: other) }
      it { should_not be_able_to :select_best, create(:answer, question: question_other, user: user) }
    end
  end
end
