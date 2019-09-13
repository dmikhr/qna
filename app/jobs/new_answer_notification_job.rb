class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(question)
    Services::NewAnswerNotification.new.notify(question)
  end
end
