require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should have_db_column(:body).of_type(:text) }
  it { should have_db_column(:best).of_type(:boolean) }
  it { should have_db_column(:user_id).of_type(:integer) }

  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }

  describe 'select_best method' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answers) { create_list(:answer, 5, question: question, user: user) }

    scenario 'select answer as best' do
      expect{ answers[-1].select_best }.to change{ answers[-1].best }.from(false).to(true)
      answers[0, answers.size - 1].each { |answer| expect(answer.best).to eq(false) }
    end

    scenario 'change best answers' do
      answers[-1].select_best
      answers[0].select_best

      answers[-1].reload
      answers[0].reload

      expect(answers[-1].best).to eq(false)
      expect(answers[0].best).to eq(true)
    end
  end
end
