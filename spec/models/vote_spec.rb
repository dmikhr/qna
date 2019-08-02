require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should have_db_column(:value).of_type(:integer) }

  it { should belong_to :user }
  it { should belong_to :votable }

  it { should validate_presence_of :user }
  it { should validate_presence_of :value }
  it { should validate_numericality_of(:value).only_integer }

  describe 'uniqueness of user scoped to votable' do
    let(:user) { create(:user) }
    let(:votable_question) { create(:question, id: 1, user: user) }
    let(:votable_answer) { create(:answer, id: 1, question: votable_question, user: user) }
    let!(:upvote_question) { create(:vote, user: user, votable: votable_question, value: 1) }
    let!(:upvote_answer) { create(:vote, user: user, votable: votable_answer, value: 1) }

    it { should validate_uniqueness_of(:user).scoped_to([:votable_id, :votable_type]) }
  end
end
