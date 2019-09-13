require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:service) { double('Service::NewAnswerNotification') }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  before do
    allow(Services::NewAnswerNotification).to receive(:new).and_return(service)
  end

  it 'calls Service::NewAnswerNotification#notify' do
    expect(service).to receive(:notify)
    NewAnswerNotificationJob.perform_now(question)
  end
end
