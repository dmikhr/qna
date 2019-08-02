require 'rails_helper'

shared_examples_for 'voted' do
  describe 'PATCH #upvote' do
    context "User that isn't an author" do
      before { login(user_voter) }

      it 'upvotes' do
        expect { patch :upvote, params: { id: votable, format: :json } }.to change{ votable.score }.by(1)
      end

      it 'returns data in json' do
        patch :upvote, params: { id: votable, format: :json }
        expect(JSON.parse(response.body).keys).to eq ["item_name", "item_id", "score"]
      end
    end

    context "Author of item" do
      before { login(author) }

      it 'upvotes' do
        expect { patch :upvote, params: { id: votable, format: :json } }.to_not change{ votable.score }
      end

      it 'error response' do
        patch :upvote, params: { id: votable, format: :json }
        expect(response.status).to eq 403
        expect(JSON.parse(response.body)["message"]).to include "Author or unauthorized user can't vote"
      end
    end

    context "Unauthorized user" do
      it 'upvotes' do
        expect { patch :upvote, params: { id: votable, format: :json } }.to_not change{ votable.score }
      end

      it 'login message' do
        patch :upvote, params: { id: votable, format: :json }
        expect(response.status).to eq 401
        expect(JSON.parse(response.body)["error"]).to include "You need to sign in or sign up before continuing."
      end
    end
  end

  describe 'PATCH #downvote' do
    context "User that isn't an author" do
      before { login(user_voter) }

      it 'downvotes' do
        expect { patch :downvote, params: { id: votable, format: :json } }.to change{ votable.score }.by(-1)
      end

      it 'returns data in json' do
        patch :downvote, params: { id: votable, format: :json }
        expect(JSON.parse(response.body).keys).to eq ["item_name", "item_id", "score"]
      end
    end

    context "Author of item" do
      before { login(author) }

      it 'downvotes' do
        expect { patch :downvote, params: { id: votable, format: :json } }.to_not change{ votable.score }
      end

      it 'error response' do
        patch :downvote, params: { id: votable, format: :json }
        expect(response.status).to eq 403
        expect(JSON.parse(response.body)["message"]).to include "Author or unauthorized user can't vote"
      end
    end

    context "Unauthorized user" do
      it 'downvotes' do
        expect { patch :downvote, params: { id: votable, format: :json } }.to_not change{ votable.score }
      end

      it 'login message' do
        patch :downvote, params: { id: votable, format: :json }
        expect(response.status).to eq 401
        expect(JSON.parse(response.body)["error"]).to include "You need to sign in or sign up before continuing."
      end
    end
  end

  describe 'PATCH #cancel_vote' do
    context "User that isn't an author" do
      before { login(user_voter) }

      it 'cancel vote' do
        patch :upvote, params: { id: votable, format: :json }
        expect { patch :cancel_vote, params: { id: votable, format: :json } }.to change{ votable.score }.from(1).to(0)
      end

      it 'returns data in json' do
        patch :cancel_vote, params: { id: votable, format: :json }
        expect(JSON.parse(response.body).keys).to eq ["item_name", "item_id", "score"]
      end
    end

    context "Author of item" do
      before { login(author) }

      it 'cancel vote' do
        patch :upvote, params: { id: votable, format: :json }
        expect { patch :cancel_vote, params: { id: votable, format: :json } }.to_not change{ votable.score }
      end

      it 'error response' do
        patch :cancel_vote, params: { id: votable, format: :json }
        expect(response.status).to eq 403
        expect(JSON.parse(response.body)["message"]).to include "Author or unauthorized user can't vote"
      end
    end

    context "Unauthorized user" do
      it 'cancel vote' do
        patch :upvote, params: { id: votable, format: :json }
        expect { patch :cancel_vote, params: { id: votable, format: :json } }.to_not change{ votable.score }
      end

      it 'login message' do
        patch :cancel_vote, params: { id: votable, format: :json }
        expect(response.status).to eq 401
        expect(JSON.parse(response.body)["error"]).to include "You need to sign in or sign up before continuing."
      end
    end
  end
end
