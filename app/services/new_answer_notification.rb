class Services::NewAnswerNotification
  def self.call(question)
    question.subscriptions.find_each do |subscription|
      NewAnswerNotificationMailer.notify(subscription.user, question).deliver_later
    end
  end
end
