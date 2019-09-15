class ReputationJob < ApplicationJob
  queue_as :default

  def perform(object)
    Services::Reputation.call(object)
  end
end
