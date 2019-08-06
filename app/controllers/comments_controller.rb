# контроллер comments не стал выделять в concern, т.к. у комментария
# также как у вопроса и ответа есть метод create - будет пересечение

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    allowed_commentables = %w[question answer]
    commentable_name = allowed_commentables.filter{ |commentable| params.keys.include?("#{commentable}_id") }
    if commentable_name.size > 0
      commentable_class = commentable_name[0].capitalize.constantize
      @commentable = commentable_class.find(params["#{commentable_name[0]}_id".to_sym])
    end
  end
end
