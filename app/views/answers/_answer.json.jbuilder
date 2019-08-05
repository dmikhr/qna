json.set! :answer do
  json.set! :id, answer.id
  json.set! :body, answer.body
  json.set! :best, answer.best
  json.set! :user_id, answer.user_id
  json.set! :question_id, answer.question_id
  json.set! :select_best_answer_path, select_best_answer_path(answer)
  json.set! :vote_item_id, vote_item_id(answer)
  json.set! :score, answer.score
end
