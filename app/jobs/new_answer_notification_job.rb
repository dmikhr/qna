class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(question)
    Services::NewAnswerNotification.call(question)
  end
end
