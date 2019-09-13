class Services::NewAnswerNotification
  def notify(question)
    question.subscriptions.find_each(batch_size: 500) do |subscription|
      NewAnswerNotificationMailer.notify(subscription.user, question).deliver_later
    end
  end
end
