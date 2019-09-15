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

    context 'Question' do
      it { should be_able_to :create, Question }

      it { should be_able_to :update, create(:question, user: user) }
      it { should_not be_able_to :update, create(:question, user: other) }

      it { should be_able_to :destroy, create(:question, user: user) }
      it { should_not be_able_to :destroy, create(:question, user: other) }

      it { should be_able_to [:upvote, :cancel_vote, :downvote], create(:question, user: other) }
      it { should_not be_able_to [:upvote, :cancel_vote, :downvote], create(:question, user: user) }
    end

    context 'Answer' do
      it { should be_able_to :create, Answer }

      it { should be_able_to :update, create(:answer, question: question, user: user) }
      it { should_not be_able_to :update, create(:answer, question: question, user: other) }

      it { should be_able_to :destroy, create(:answer, question: question, user: user) }
      it { should_not be_able_to :destroy, create(:answer, question: question, user: other) }

      it { should be_able_to [:upvote, :cancel_vote, :downvote], create(:answer, question: question, user: other) }
      it { should_not be_able_to [:upvote, :cancel_vote, :downvote], create(:answer, question: question, user: user) }

      it { should be_able_to :select_best, create(:answer, question: question, user: other) }
      it { should_not be_able_to :select_best, create(:answer, question: question_other, user: user) }
    end

    context 'Comment' do
      it { should be_able_to :create, Comment }
    end

    context 'Link' do
      it { should be_able_to :destroy, create(:link, linkable: question) }
      it { should_not be_able_to :destroy, create(:link, linkable: question_other) }
    end

    context 'Attachment' do
      it { should be_able_to :destroy, ActiveStorage::Attachment }
    end

    context 'Profile' do
      it { should be_able_to [:index, :me], User }
    end

    context 'Subscription' do
      it { should be_able_to :create, Subscription }
      it { should_not be_able_to :destroy, create(:subscription, user: other, subscribable: question_other) }
    end
  end
end
