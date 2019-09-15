class NewAnswerNotificationMailer < ApplicationMailer
  def notify(user, question)
    @question = question
    mail to: user.email, subject: 'New answer'
  end
end
