require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes) }

  context 'user' do
    it 'upvotes' do
      expect{ votable.upvote }.to change{ votable.score }.by(1)
    end

    it 'downvotes' do
      expect{ votable.downvote }.to change{ votable.score }.by(-1)
    end

    it 'cancel vote' do
      expect do
        votable.downvote
        votable.cancel_vote
      end.to_not change{ votable.score }
    end

    it 'tries to upvote twice' do
      expect do
        votable.upvote
        votable.upvote
      end.to change{ votable.score }.by(1)
    end

    it 'tries to downvote twice' do
      expect do
        votable.downvote
        votable.downvote
      end.to change{ votable.score }.by(-1)
    end

    it 'changes vote to opposite' do
      expect do
        votable.upvote
        votable.cancel_vote
        votable.downvote
      end.to change{ votable.score }.by(-1)
    end
  end

  context 'users' do
    let!(:upvote1) { create(:vote, user: user, votable: votable, value: 1) }
    let!(:upvote2) { create(:vote, user: user2, votable: votable, value: 1) }
    let!(:downvote1) { create(:vote, user: user, votable: votable_down, value: -1) }
    let!(:downvote2) { create(:vote, user: user2, votable: votable_down, value: -1) }

    it 'upvote' do
      expect(votable.score).to eq 2
    end

    it 'downvote' do
      expect(votable_down.score).to eq -2
    end
  end
end
