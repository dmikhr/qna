require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do

  it 'calls Service::DailyDigest#call' do
    expect(Services::DailyDigest).to receive(:call)
    DailyDigestJob.perform_now
  end
end
