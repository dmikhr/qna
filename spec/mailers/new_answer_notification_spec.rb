require "rails_helper"

RSpec.describe NewAnswerNotificationMailer, type: :mailer do
  describe "notify" do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:mail) { NewAnswerNotificationMailer.notify(user, question) }

    it "renders the headers" do
      expect(mail.subject).to eq("New answer")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(question.title)
    end
  end
end
