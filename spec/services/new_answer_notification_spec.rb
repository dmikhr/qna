require 'rails_helper'

RSpec.describe Services::NewAnswerNotification do
  let(:user) {create(:user)}
  let(:user2) {create(:user)}
  let(:user_author) {create(:user)}
  let(:question) {create(:question, user: user_author)}
  let!(:subscription) { create(:subscription, user: user, subscribable: question) }
  let!(:subscription2) { create(:subscription, user: user2, subscribable: question) }

  before { Sidekiq::Testing.fake! }

  it 'sends notifications about new answers to subscribed users' do
    [user, user2, user_author].each do |user|
      expect(NewAnswerNotificationMailer).to receive(:notify).with(user, question).and_call_original
    end

    Services::NewAnswerNotification.call(question)
  end

  after { Sidekiq::Testing.disable! }
end
