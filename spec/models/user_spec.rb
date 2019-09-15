require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:authorizations).dependent(:destroy) }

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

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).and_return(service)
      expect(service).to receive(:call).with(auth)
      User.find_for_oauth(auth)
    end
  end

  describe '.create_by_email' do
    let!(:user) { create(:user, email: 'registered@user.com') }

    it 'create new user' do
      expect{ User.create_by_email('new@user.com') }.to change(User, :count).by(1)
    end

    it "don't create user if it already exists" do
      expect{ User.create_by_email('registered@user.com') }.to_not change(User, :count)
    end
  end

  describe 'Subscription' do
    let(:user) { create(:user) }
    let(:user_other) { create(:user) }
    let(:author) { create(:user) }
    let(:question) { create(:question, user: author) }
    let(:subscription) { create(:subscription, user: user, subscribable: question) }

    it 'user is subscribed' do
      expect(user.subscribed?(subscription.subscribable)).to be_truthy
    end

    it 'author is subscribed' do
      expect(author.subscribed?(question)).to be_truthy
    end

    it 'other user is not subscribed' do
      expect(user_other.subscribed?(question)).to be_falsey
    end
  end
end
