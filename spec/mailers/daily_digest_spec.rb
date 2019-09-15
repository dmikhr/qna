require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let!(:questions) { create_list(:question, 3, user: user) }
    let!(:question_2days_ago) { create(:question, user: user, created_at: 2.day.ago) }
    let(:mail) { DailyDigestMailer.digest(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")

      questions.each do |question|
        expect(mail.body.encoded).to match(question.title)
      end

      expect(mail.body.encoded).to_not match(question_2days_ago.title)
    end
  end

end
