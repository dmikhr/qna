module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable
  end

  def upvote
    return render_errors unless helpers.can_vote?(@votable)
    @votable.upvote
    render_json
  end

  def downvote
    return render_errors unless helpers.can_vote?(@votable)
    @votable.downvote
    render_json
  end

  def cancel_vote
    return render_errors unless helpers.can_vote?(@votable)
    @votable.cancel_vote
    render_json
  end

  private

  def render_errors
    render json: { message: "Author or unauthorized user can't vote" }, status: :forbidden
  end

  def render_json
    render json: { item_name: item_name, item_id: @votable.id, score: @votable.score }
  end

  def item_name
    @votable.class.name.underscore
  end

  def votable_id
    return false unless params[:id]
    params.require(:id)
  end

  def set_votable
    @votable = controller_name.classify.constantize.find(votable_id) if votable_id
  end
end
