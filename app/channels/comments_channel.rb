class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "comments_of_question_#{params[:question_id]}"
  end
end
