json.set! :comment do
  json.set! :id, comment.id
  json.set! :user_id, comment.user_id
  json.set! :body, comment.body
  json.set! :commentable_label, commentable_label(comment.commentable)
end
